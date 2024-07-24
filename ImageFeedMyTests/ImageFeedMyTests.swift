//
//  ImageFeedMyTests.swift
//  ImageFeedMyTests
//
//  Created by Александр Верповский on 17.07.2024.
//

@testable import ImageFeedMy
import XCTest

final class WebViewViewControllerSpy: UIViewController {
    
    var loadRequestCalled = false
}

final class WebViewTests: XCTestCase {
    
    func testPresenterCallsLoadRequest() {
        // Given
        let presenter = WebViewPresenterSpy()
        let viewController = WebViewVC()
        viewController.webViewPresenter = presenter
        presenter.view = viewController
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
    
    //MARK: Устранение замечаний - testCodeFromURL
    //MARK: ( AuthHelper().testCodeFromURL() ) Я презенторы начал делать с самого начала курса, поэтому слегка отличаются названия классов. Вот тест, который проверяет корректность распознавания ссылки, пеперисывать сейчас презентер под урок, увы, времени нет. Дедлайн горит :(
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
    //MARK: Устранение замечаний - testProgressHiddenWhenOne
    func testProgressHiddenWhenOne() {
        let presenter = WebViewPresenter()
        let progress: Float = 1.0
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(shouldHideProgress)
    }
}
