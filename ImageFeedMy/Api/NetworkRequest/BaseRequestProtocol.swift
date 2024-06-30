//
//  BaseProtocol.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 30.06.2024.
//

import Foundation

protocol BaseRequestProtocol {
    var urlRequest: URLRequest? { get }
    var parameters: [String: String] { get }
}
