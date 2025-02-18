//
//  OAuth2Service.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 18.06.2024.
//

import Foundation

final class OAuth2Service {
    private static let SERVICE_NAME = "OAuth2Service"
    
    static let shared = OAuth2Service()
    
    private var model: OAuthTokenResponseBody?
    private var workItem: DispatchWorkItem?
    private var lastCode: String?
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code
        else {
            completion(.failure(Constants.NetworkError.noUrlRequest))
            return
        }
        
        workItem?.cancel()
        lastCode = code
        
        let request = OAuth2Request(code: code)
        
        //TODO: Нужен совет по безопасности и многопоточности :)
        workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            NetworkApi.shared.sendRequest(request: request, model: model) { [weak self] response in
                guard let self else { return }
                switch response {
                case .success(let data):
                    OAuth2TokenStorage.shared.token = data?.accessToken
                    completion(.success(model?.accessToken ?? ""))
                case .failure(let error):
                    completion(.failure(Constants.NetworkError.otherError(error)))
                    Log.createlog(log: LogModel(serviceName: OAuth2Service.SERVICE_NAME, message: "Ошибка при обработке запроса на получение токена", systemError: error.localizedDescription, eventType: .error))
                }
            }
        }
        
        if let workItem = workItem { DispatchQueue.global().async(execute: workItem) }
    }
}
