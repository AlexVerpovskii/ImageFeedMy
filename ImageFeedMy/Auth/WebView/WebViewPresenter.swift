//
//  WebViewPresenter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 16.06.2024.
//

import Foundation
import WebKit

protocol WebViewProtocol {
    func loadAuth() -> URLRequest
    func code(from navigationAction: WKNavigationAction) -> String?
}

//TODO: Вопрос: Нужен ли тут вообще протокол или проще его убрать и работать в controller напрямую?
final class WebViewPresenter {
    
    private func loadAuthView() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Schema.https
        urlComponents.host = Constants.Unsplash.host
        urlComponents.path = Constants.Unsplash.pathAuthorize
        
        urlComponents.queryItems = [
            URLQueryItem(name: Constants.Unsplash.QueryItem.clientId, value: Constants.Unsplash.accessKey),
            URLQueryItem(name: Constants.Unsplash.QueryItem.redirectUri, value: Constants.Unsplash.redirectUri),
            URLQueryItem(name: Constants.Unsplash.QueryItem.responseType, value: Constants.Unsplash.code),
            URLQueryItem(name: Constants.Unsplash.QueryItem.scope, value: Constants.Unsplash.accessScope)
        ]
        
        //TODO: Избавиться от строки
        guard let url = urlComponents.url else { fatalError("invalid url") }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.HTTPMethod.get
        return request
    }
    
    private func getCode(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlCompnents = URLComponents(string: url.absoluteString),
            urlCompnents.path == Constants.Unsplash.pathAuthorize + Constants.Unsplash.native,
            let items = urlCompnents.queryItems,
            let codeItem = items.first(where: {$0.name == Constants.Unsplash.code }) 
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

extension WebViewPresenter: WebViewProtocol {
    func loadAuth() -> URLRequest {
        return loadAuthView()
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        return getCode(from: navigationAction)
    }
}
