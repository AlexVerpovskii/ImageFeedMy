//
//  OAuth2Request.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 30.06.2024.
//

import Foundation

final class OAuth2Request: BaseRequestImpl {
    private final let code: String
    
    init(code: String) {
        self.code = code
    }
    
    override var httpMethod: HttpMethod { .post }
    
    override var endPoint: String { Constants.Unsplash.pathToken }
    
    override var parameters: [String : String] {
        return [
            Constants.Unsplash.QueryItem.clientId : Constants.Unsplash.accessKey,
            Constants.Unsplash.QueryItem.clientSecret : Constants.Unsplash.secretKey,
            Constants.Unsplash.QueryItem.redirectUri : Constants.Unsplash.redirectUri,
            Constants.Unsplash.code : code,
            Constants.Unsplash.QueryItem.grantType : Constants.Unsplash.authorizationCode
        ]}
    
}
