//
//  NetworkApi.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 30.06.2024.
//

import Foundation

typealias NetworkError = Constants.NetworkError

final class NetworkApi {
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
                    //add log invalid data decoder
                    completion(.failure(.invalidDecoder))
                    print(error)
                }
            case .failure(let error):
                //add log
                completion(.failure(.otherError(error)))
                print(error)
            }
        }.resume()
    }
}
