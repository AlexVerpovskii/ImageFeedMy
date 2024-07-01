//
//  ProfileReqeust.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 01.07.2024.
//

import Foundation

final class ProfileRequest: BaseRequestImpl {
    
    override var host: String { Constants.Unsplash.defaultApiUrl}
    override var endPoint: String { Constants.Unsplash.pathProfile }
    override var token: String { OAuth2TokenStorage.shared.token ?? "" }
}
