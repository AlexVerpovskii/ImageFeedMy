//
//  ImageFeedMyTests.swift
//  ImageFeedMyTests
//
//  Created by Александр Верповский on 17.07.2024.
//

@testable import ImageFeedMy
import XCTest

final class WebViewPresenterSpy: WebViewProtocol {
    
    func code(from url: String) -> String? {
        nil
    }
    
    var viewDidLoadCalled = false
    
    func loadAuth() -> URLRequest? {
        viewDidLoadCalled.toggle()
        return nil
    }
}

final class WebViewViewControllerSpy: UIViewController {
    
    var loadRequestCalled = false
}

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = WebViewVC()
        let presenter = WebViewPresenterSpy()
        viewController.webViewPresenter = presenter

        // When
        let _ = viewController.view
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testAuthURL() {
        let configuration = AuthConfiguration.standard
        //given
        let presenter = WebViewPresenter()
        
        //when
        guard let request = presenter.loadAuth(), let url = request.url else { return }
        
        //then
        XCTAssertTrue(url.absoluteString.contains(configuration.authURLString))
        XCTAssertTrue(url.absoluteString.contains(configuration.accessKey))
        XCTAssertTrue(url.absoluteString.contains(configuration.redirectURI))
        XCTAssertTrue(url.absoluteString.contains("code"))
        XCTAssertTrue(url.absoluteString.contains(configuration.accessScope))
    }
    
    func testCodeFromUrl() {
        // Given
        let presenter = WebViewPresenter()
        var urlComponents = URLComponents()
        urlComponents.path = "/oauth/authorize/native"
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "testValue")]
        guard let url = urlComponents.url else { return }

        // When
        let code = presenter.code(from: url.absoluteString)

        // Then
        XCTAssertEqual(code, "testValue")
    }
}
