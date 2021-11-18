/*
 MIT License

 Copyright (c) 2021 Dionysios Karatzas

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import XCTest

// swiftlint:disable all
class WeatherScreenTests: WeatherUITest {
	var mainScreen: MainScreen!
	var weatherScreen: WeatherScreen!

	override func setUp() {
		super.setUp()

		mainScreen = MainScreen(app)
	}

	func testSheetActionsExists() {
		weatherScreen = mainScreen.selectFirstPlaceFromSearch()

		XCTAssertTrue(weatherScreen.cancelButton.exists)
		XCTAssertTrue(weatherScreen.addButton.exists)
		XCTAssertFalse(weatherScreen.dismissButton.exists)
	}

	func testSheetActionsNotExists() {
		weatherScreen = mainScreen.selectFirstPlaceFromSearch()
		weatherScreen.tapAddButton()
		weatherScreen = mainScreen.selectFirstPlace()

		XCTAssertFalse(weatherScreen.cancelButton.exists)
		XCTAssertFalse(weatherScreen.addButton.exists)
		XCTAssertTrue(weatherScreen.dismissButton.exists)
	}

	func testScreenDataDisplaying() {
		weatherScreen = mainScreen.selectFirstPlaceFromSearch()

		XCTAssertTrue(app.staticTexts["Athens"].exists)
		XCTAssertTrue(app.staticTexts["Partly cloudy - Feels like 16º"].exists)
		XCTAssertTrue(app.staticTexts["16º"].exists)
		XCTAssertTrue(app.staticTexts["UV: 4"].exists)
		XCTAssertTrue(app.staticTexts["59%"].exists)
		XCTAssertTrue(app.staticTexts["31km/h"].exists)
		XCTAssertTrue(app.staticTexts["N"].exists)
		XCTAssertTrue(app.staticTexts["7:07 AM"].exists)
		XCTAssertTrue(app.staticTexts["5:13 PM"].exists)


		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["12 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["1 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["2 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["3 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["4 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["5 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["6 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["7 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["8 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["9 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["10 AM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["11 AM"].exists)

		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["12 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["1 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["2 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["3 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["4 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["5 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["6 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["7 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["8 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["9 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["10 PM"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["11 PM"].exists)

		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["Today"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["16º / 12º"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["Wednesday"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["16º / 10º"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["Thursday"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["17º / 10º"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["Friday"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["16º / 11º"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["Saturday"].exists)
		XCTAssertTrue(app.scrollViews.otherElements.staticTexts["17º / 10º"].exists)
	}

	func testCancelButton() {
		weatherScreen = mainScreen.selectFirstPlaceFromSearch()
		weatherScreen.tapCancelButton()
		sleep(2)
		XCTAssertFalse(weatherScreen.cancelButton.exists)
	}

	func testDismissButton() {
		weatherScreen = mainScreen.selectFirstPlaceFromSearch()
		weatherScreen.tapAddButton()
		weatherScreen = mainScreen.selectFirstPlace()
		weatherScreen.tapDismissButton()
		sleep(2)
		XCTAssertFalse(weatherScreen.dismissButton.exists)
	}
}
