//
//  WebViewPresenterSpy.swift
//  ImageFeedMyTests
//
//  Created by Александр Верповский on 25.07.2024.
//

@testable import ImageFeedMy
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    var view: (any ImageFeedMy.WebViewViewControllerProtocol)?
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    
    func code(from url: String) -> String? {
        nil
    }
    
    var viewDidLoadCalled = false

}
