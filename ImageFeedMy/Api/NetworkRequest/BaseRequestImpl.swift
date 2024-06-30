//
//  BaseRequestImpl.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 30.06.2024.
//

import Foundation

typealias Scheme = Constants.Schema
typealias HttpMethod = Constants.HTTPMethod

class BaseRequestImpl: BaseRequestProtocol {
    
    var scheme: Scheme { return .https }
    
    var host: String { return Constants.Unsplash.host}
    
    //TODO: Когда появятся post запросы
//    var httpBody: Data? { return nil }
    
    var httpMethod: HttpMethod { return .get }
    
    var endPoint: String { return ""}
    
    var parameters: [String: String] { return [:] }
    
    var token: String { return ""}
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        urlComponents.path = "/" + endPoint
        urlComponents.setQueryItems(with: parameters)
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        //TODO: Когда появятся post запросы
//        request.httpBody = httpBody
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !token.isEmpty {
            request.setValue(Constants.Unsplash.bearer +
                             " " +
                             token,
                             forHTTPHeaderField:Constants.Unsplash.authorization)
        }
        return request
    }
}

private extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
