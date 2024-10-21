import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        app.launchArguments = ["testMode"] // чтобы понимать, когда код запущен в тестовом режиме
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    // тестируем сценарий авторизации
    func testAuth() throws {
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        sleep(1)
        loginTextField.typeText("fake@email.com")
        let startPoint1 = loginTextField.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finishPoint1 = loginTextField.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: -5))
        startPoint1.press(forDuration: 0, thenDragTo: finishPoint1)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        sleep(1)
        passwordTextField.typeText("1234567890")
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    // тестируем сценарий ленты
    func testFeed() throws {
        let cellsQuery = app.tables.children(matching: .cell)
        
        let cell = cellsQuery.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        app.swipeUp()
        sleep(1)
        
        // берем первую доступную для тапа ячейку
        guard let cellToLike = cellsQuery.allElementsBoundByIndex.first(where: { $0.buttons["like button"].exists && $0.buttons["like button"].isHittable }) else {
            XCTFail("Cell to like not found or not hittable")
            return
        }

        cellToLike.buttons["like button"].tap()
        sleep(1)
        cellToLike.buttons["like button"].tap()
        sleep(1)
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        image.pinch(withScale: 3, velocity: 1) // Zoom in
        image.pinch(withScale: 0.5, velocity: -1) // Zoom out
        
        let navBackButtonWhiteButton = app.buttons["nav back button"]
        navBackButtonWhiteButton.tap()
    }
    
    // тестируем сценарий профиля
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["Evgenii Sokolov"].exists)
        XCTAssertTrue(app.staticTexts["@nutsokol"].exists)
        
        app.buttons["logout button"].tap()
        
        app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }
}
