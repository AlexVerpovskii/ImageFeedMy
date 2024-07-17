//
//  ProfileLogoutService.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 14.07.2024.
//

import Foundation
import WebKit
import Kingfisher

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanImageCache()
        clearImageList()
        
        OAuth2TokenStorage.shared.removeAllKeys()
        ImagesListService.shared.cleanPhoto()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanImageCache() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
    
    private func clearImageList() {
        let imagesListPresenter = ImagesListPresenter()
        imagesListPresenter.photos = []
    }
    
}
