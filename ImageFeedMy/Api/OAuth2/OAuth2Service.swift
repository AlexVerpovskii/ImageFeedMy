//
//  OAuth2Service.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()

    private var model: OAuthTokenResponseBody?
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        let request = OAuth2Request(code: code)
        NetworkApi.shared.sendRequest(request: request, model: model) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let data):
                OAuth2TokenStorage.shared.token = data?.accessToken
                completion(.success(model?.accessToken ?? ""))
            case .failure(let error):
                completion(.failure(Constants.NetworkError.otherError(error)))
            }
        }
    }
}
