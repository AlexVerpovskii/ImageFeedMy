//
//  ImageFeedMyUITests.swift
//  ImageFeedMyUITests
//
//  Created by Александр Верповский on 21.07.2024.
//

@testable import ImageFeedMy
import XCTest

//MARK: По поводу мелких замечаний в ПР, поправлю, но уже когда будет свободное время. Сейчас в приоритете критикал замечания, чтоб закрыть спринт :)
final class ImageFeedMyUITest: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["TestMode"]
        app.launch()
    }
    
    //MARK: Бывает такой кейс: Когда нажимаешь "войти" происходит редирект, в кэше уже хранятся твои данные, и вместо окна с логином и паролем, сразу прлучаешь код и переходишь на другой контроллер. Решается такая проблема полной очисткой куки (кнопка лагаут)
    func testAuth() throws {
        let authButton = app.buttons["Authenticate"]
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
        
        //MARK: иногда вводится 3-4 символа в пароле, вместо нужнного N. Данная проблема была у многих, посоветовали усыплять поток на секунду, надеюсь, у тебя будет все ок
        passwordTF.tap()
        passwordTF.typeText("RbXdM$ZENp#*9tU")
        sleep(3)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        app.swipeUp()
        app.swipeDown()
        
        let tablesQuery = app.tables
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        let likeButton = cellToLike.buttons["like"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        

        likeButton.tap()
        sleep(5)
        likeButton.tap()
        
        sleep(10)
        
        cellToLike.tap()
        
        sleep(2)
        
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
