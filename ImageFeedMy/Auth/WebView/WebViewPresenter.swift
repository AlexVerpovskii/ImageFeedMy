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
    
    private func getCode(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlCompnents = URLComponents(string: url.absoluteString),
            urlCompnents.path == "/" + Constants.Unsplash.pathAuthorize + Constants.Unsplash.native,
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
        guard let request = WebViewRequest().urlRequest else { fatalError("log") }
        return request
    }
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        return getCode(from: navigationAction)
    }
}
