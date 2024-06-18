//
//  OAuth2Service.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private init() {}
    
    private func createURLRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Schema.https
        urlComponents.host = Constants.Unsplash.host
        urlComponents.path = Constants.Unsplash.pathToken
        
        urlComponents.queryItems = [
            URLQueryItem(name: Constants.Unsplash.QueryItem.clientId, value: Constants.Unsplash.accessKey),
            URLQueryItem(name: Constants.Unsplash.QueryItem.clientSecret, value: Constants.Unsplash.secretKey),
            URLQueryItem(name: Constants.Unsplash.QueryItem.redirectUri, value: Constants.Unsplash.redirectUri),
            URLQueryItem(name: Constants.Unsplash.code, value: code),
            URLQueryItem(name: Constants.Unsplash.QueryItem.grantType, value: Constants.Unsplash.authorizationCode)
        ]
        
        //TODO: Избавиться от строки
        guard let url = urlComponents.url else { fatalError("invalid url") }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.HTTPMethod.post
        
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        let request = createURLRequest(code: code)
        
        URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let token = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    OAuth2TokenStorage.shared.token = token.accessToken
                    completion(.success(token.accessToken))
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
}
