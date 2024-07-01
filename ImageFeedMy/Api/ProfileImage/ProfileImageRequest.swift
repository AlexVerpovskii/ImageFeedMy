//
//  ProfileImageRequest.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

final class ProfileImageRequest: BaseRequestImpl {
    
    private final let userName: String
    
    init(userName: String) {
        self.userName = userName
    }
    
    override var host: String { Constants.Unsplash.defaultApiUrl}
    override var endPoint: String { Constants.Unsplash.pathUsers + "/" + userName }
    override var token: String { OAuth2TokenStorage.shared.token ?? "" }
}
