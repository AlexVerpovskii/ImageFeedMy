//
//  LikeRequest.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 10.07.2024.
//

import Foundation

final class LikeRequest: BaseRequestImpl {
    
    private final let id: String
    
    init(id: String) {
        self.id = id
    }
    
    override var host: String { Constants.Unsplash.defaultApiUrl}
    override var httpMethod: HttpMethod { return .post }
    override var endPoint: String { return "\(Constants.Unsplash.pathPhotos)/\(id)/like" }
    override var token: String { OAuth2TokenStorage.shared.token ?? "" }
}
