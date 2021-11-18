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
class MainScreenTests: WeatherUITest {
	var mainScreen: MainScreen!

	override func setUp() {
		super.setUp()

		mainScreen = MainScreen(app)
	}

	func testSearchPlaces() {
		mainScreen.tapSearchTextField()
		mainScreen.searchFor(place: "Test")
		self.waitUntilExists(forElement: mainScreen.searchResultList, testCase: self)

		XCTAssertEqual(mainScreen.searchResultList.cells.count, 4)
		XCTAssertTrue(mainScreen.searchResultList.cells["Athens, Attica, Greece"].exists)
		XCTAssertTrue(mainScreen.searchResultList.cells["Athens, Ohio, United States of America"].exists)
		XCTAssertTrue(mainScreen.searchResultList.cells["Athens, Tennessee, United States of America"].exists)
		XCTAssertTrue(mainScreen.searchResultList.cells["Athens, Texas, United States of America"].exists)
	}

	func testSearchPlacesNoResults() {
		mainScreen.tapSearchTextField()
		mainScreen.searchFor(place: "T")

		self.waitUntilExists(forElement: mainScreen.emptyResultImage, testCase: self)

		XCTAssertTrue(mainScreen.emptyResultImage.exists)
		XCTAssertTrue(mainScreen.emptyResultLabel.exists)
		XCTAssertEqual(mainScreen.emptyResultLabel.label, L10n.noSearchResults)
	}

	func testAddPlace() {
		let weatherScreen = mainScreen.selectFirstPlaceFromSearch()
		weatherScreen.tapAddButton()

		XCTAssertTrue(mainScreen.placesScrollView.otherElements.staticTexts["Athens - Attica"].exists)
		XCTAssertTrue(mainScreen.placesScrollView.otherElements.staticTexts["Partly cloudy"].exists)
		XCTAssertTrue(mainScreen.placesScrollView.otherElements.staticTexts["16º"].exists)

	}

	func testRemovePlace() {
		let weatherScreen = mainScreen.selectFirstPlaceFromSearch()
		weatherScreen.tapAddButton()

		mainScreen.removeFirstPlace()

		XCTAssertFalse(mainScreen.placesScrollView.otherElements.staticTexts["Athens - Attica"].exists)
		XCTAssertFalse(mainScreen.placesScrollView.otherElements.staticTexts["Partly cloudy"].exists)
		XCTAssertFalse(mainScreen.placesScrollView.otherElements.staticTexts["16º"].exists)
	}

	func testNoEditButtonWhileSearch() {
		// add a place
		let weatherScreen = mainScreen.selectFirstPlaceFromSearch()
		weatherScreen.tapAddButton()

		XCTAssertTrue(mainScreen.editPlacesButton.exists)

		mainScreen.tapSearchTextField()
		mainScreen.searchFor(place: "Athens")

		XCTAssertFalse(mainScreen.editPlacesButton.exists)
	}
}
// swiftlint:enable all
