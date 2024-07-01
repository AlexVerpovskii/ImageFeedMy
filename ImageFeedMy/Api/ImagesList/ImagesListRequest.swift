//
//  ImagesListRequest.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

final class ImagesListRequest: BaseRequestImpl {
    private final let page: String
    
    init(page: String) {
        self.page = page
    }
    
    override var host: String { Constants.Unsplash.defaultApiUrl}
    override var endPoint: String { Constants.Unsplash.pathPhotos }
    override var token: String { OAuth2TokenStorage.shared.token ?? "" }
    
    override var parameters: [String : String] { return ["page": page] }
}
