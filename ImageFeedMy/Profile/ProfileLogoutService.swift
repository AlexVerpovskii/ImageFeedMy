//
//  ProfileLogoutService.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 14.07.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
   static let shared = ProfileLogoutService()
  
   private init() { }

   func logout() {
      cleanCookies()
   }
    
    //доработать удаление ImagesListService список фото ProfileImageService аватарка, переходод на ауф

   private func cleanCookies() {
      // Очищаем все куки из хранилища
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      // Запрашиваем все данные из локального хранилища
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         // Массив полученных записей удаляем из хранилища
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
}
