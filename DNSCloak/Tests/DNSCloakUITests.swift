import XCTest

class DNSCloakUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSideMenu() throws {
        let app = XCUIApplication()
        app.launch()

        app.navigationBars["DNSCloak"].buttons["line.horizontal.3"].tap()
        XCTAssertTrue(app.staticTexts["Home"].exists)
        XCTAssertTrue(app.staticTexts["Blocklists"].exists)
        XCTAssertTrue(app.staticTexts["Resolvers"].exists)
        XCTAssertTrue(app.staticTexts["Query Log"].exists)
        XCTAssertTrue(app.staticTexts["Settings"].exists)
    }
}
