//
//  NetworkApi.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 30.06.2024.
//

import Foundation

typealias NetworkError = Constants.NetworkError

final class NetworkApi {
    private static let SERVICE_NAME = "NetworkApi"
    
    static let shared = NetworkApi()
    
    private init() {}
    
    func sendRequest<Request:BaseRequestProtocol, Model: Decodable>(request: Request, model: Model, completion: @escaping (Swift.Result<Model, NetworkError>) -> Void) {
        guard let urlRequest = request.urlRequest else {
            completion(.failure(.noUrlRequest))
            return
        }
        
        URLSession.shared.data(for: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(Model.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(.invalidDecoder))
                    Log.createlog(log: LogModel(serviceName: NetworkApi.SERVICE_NAME, message: "Ошибка при обработке json'а", systemError: error.localizedDescription, eventType: .error))
                }
            case .failure(let error):
                completion(.failure(.otherError(error)))
                Log.createlog(log: LogModel(serviceName: NetworkApi.SERVICE_NAME, message: "Ошибка при обработке запроса", systemError: error.localizedDescription, eventType: .error))
            }
        }.resume()
    }
}
