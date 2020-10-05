import XCTest

class ENAUITests_01_Home: XCTestCase {
	var app: XCUIApplication!

	override func setUpWithError() throws {
		continueAfterFailure = false
		app = XCUIApplication()
		setupSnapshot(app)
		app.setDefaults()
		app.launchArguments.append(contentsOf: ["-isOnboarded", "YES"])
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func test_0010_HomeFlow_medium() throws {
		app.setPreferredContentSizeCategory(accessibililty: .normal, size: .XS)
		app.launch()

		// only run if home screen is present
		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: 5.0))

		app.swipeUp()
		// assert cells
		XCTAssert(app.cells["AppStrings.Home.infoCardShareTitle"].waitForExistence(timeout: 5.0))
		XCTAssert(app.cells["AppStrings.Home.infoCardAboutTitle"].waitForExistence(timeout: 5.0))
		XCTAssert(app.cells["AppStrings.Home.appInformationCardTitle"].waitForExistence(timeout: 5.0))
		XCTAssert(app.cells["AppStrings.Home.settingsCardTitle"].waitForExistence(timeout: 5.0))
		//snapshot("ScreenShot_\(#function)")
	}

	func test_0011_HomeFlow_extrasmall() throws {
		app.setPreferredContentSizeCategory(accessibililty: .normal, size: .M)
		app.launch()

		// only run if home screen is present
		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: 5.0))

		app.swipeUp()
		// assert cells
		XCTAssert(app.cells["AppStrings.Home.infoCardShareTitle"].waitForExistence(timeout: 5.0))
		XCTAssert(app.cells["AppStrings.Home.infoCardAboutTitle"].waitForExistence(timeout: 5.0))
		XCTAssert(app.cells["AppStrings.Home.appInformationCardTitle"].waitForExistence(timeout: 5.0))
		XCTAssert(app.cells["AppStrings.Home.settingsCardTitle"].waitForExistence(timeout: 5.0))
		//snapshot("ScreenShot_\(#function)")
	}

	func test_0013_HomeFlow_extralarge() throws {
		app.setPreferredContentSizeCategory(accessibililty: .accessibility, size: .XL)
		app.launch()

		// only run if home screen is present
		XCTAssert(app.buttons["AppStrings.Home.rightBarButtonDescription"].waitForExistence(timeout: 5.0))

		app.swipeUp()
		app.swipeUp()
		// assert cells
		XCTAssert(app.cells["AppStrings.Home.infoCardShareTitle"].waitForExistence(timeout: 5.0))
		XCTAssert(app.cells["AppStrings.Home.infoCardAboutTitle"].waitForExistence(timeout: 5.0))
		app.swipeUp()
		XCTAssert(app.cells["AppStrings.Home.appInformationCardTitle"].waitForExistence(timeout: 5.0))
		XCTAssert(app.cells["AppStrings.Home.settingsCardTitle"].waitForExistence(timeout: 5.0))
		//snapshot("ScreenShot_\(#function)")
	}
}
