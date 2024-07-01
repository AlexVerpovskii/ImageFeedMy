//
//  Constants.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 06.05.2024.
//

import Foundation

enum Constants {
    enum SettingsKeys: String {
        case token
    }
    
    enum ImageNames {
        static let likeOn = "like_on"
        static let likeOff = "like_off"
        static let exitButtonIcon = "exit_image"
        static let backwardButton = "backward"
        static let sharingButton = "Sharing"
        static let tabBarImageLeft = "l_Active_on"
        static let tabBarImagRight = "r_Active_on"
        static let logo = "logo"
        static let vector = "Vector"
        static let avatar = "avatar"
    }
    
    enum Other {
        static let reuseIdentifier = "ImagesListCell"
        static let dateFormat = "dd MMMM yyyy"
        static let formatterLocal = "ru_RU"
        static let empty = ""
    }
    
    enum Unsplash {
        static let accessKey = "iYvSt9RTk4aHHX2aFooC9DdE2L_AyIxEaNi4IGP8PlY"
        static let secretKey = "hRkIvS8mskQ7NsdRM6VaQoqmWSoUW1fsvCsOTtA5RLs"
        static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
        static let host = "unsplash.com"
        static let pathAuthorize = "oauth/authorize"
        static let native = "/native"
        static let code = "code"
        static let pathToken = "oauth/token"
        static let authorizationCode = "authorization_code"
        static let pathProfile = "me"
        static let pathUsers = "users"
        static let bearer = "Bearer"
        static let authorization = "Authorization"
        static let defaultApiUrl = "api.unsplash.com"
        enum QueryItem {
            static let clientId = "client_id"
            static let redirectUri = "redirect_uri"
            static let responseType = "response_type"
            static let grantType = "grant_type"
            static let scope = "scope"
            static let clientSecret = "client_secret"
        }
    }
    
    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
    }
    
    enum Schema: String {
        case http = "http"
        case https = "https"
    }
    
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case noUrlRequest
        case urlSessionError
        
        
        case otherError(Error)
        case invalidDecoder
    }
}
