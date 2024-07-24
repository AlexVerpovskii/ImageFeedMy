//
//  WebViewPresenter.swift
//  ImageFeedMy
//
//  Created by Александр Верповский on 16.06.2024.
//

import Foundation
import WebKit

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: String) -> String?
    func viewDidLoad()
}

//TODO: Вопрос: Нужен ли тут вообще протокол или проще его убрать и работать в controller напрямую?
final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        view?.load(request: loadAuth()!)
    }
    
    private func getCode(from url: String) -> String? {
        if
            let urlCompnents = URLComponents(string: url),
            urlCompnents.path == "/" + Constants.Unsplash.pathAuthorize + Constants.Unsplash.native,
            let items = urlCompnents.queryItems,
            let codeItem = items.first(where: {$0.name == Constants.Unsplash.code })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func loadAuth() -> URLRequest? {
        guard let request = WebViewRequest().urlRequest else { fatalError("log") }
        return request
    }
    
    func code(from url: String) -> String? {
        return getCode(from: url)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
}
