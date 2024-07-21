//
//  ImageFeedMyUITests.swift
//  ImageFeedMyUITests
//
//  Created by Александр Верповский on 21.07.2024.
//

@testable import ImageFeedMy
import XCTest

final class ImageFeedMyUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        let authButton = app.buttons["Authenticate"]
        
        XCTAssertNotNil(authButton)
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
        authButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTF = webView.descendants(matching: .textField).element
        loginTF.tap()
        loginTF.typeText("alex.verpovskii@gmail.com")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        webView.swipeUp()
        
        let passwordTF = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTF.waitForExistence(timeout: 5))
        
        passwordTF.tap()
        passwordTF.typeText("")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        app.swipeUp()
        sleep(5)
        app.swipeDown()
        sleep(5)
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        sleep(5)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like"].tap()
        sleep(5)
        cellToLike.buttons["like"].tap()
        
        sleep(5)
        
        cellToLike.tap()
        
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Alex Verpovskii"].exists)
        XCTAssertTrue(app.staticTexts["@averpovskii"].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}
