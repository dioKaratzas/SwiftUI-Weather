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

class MainScreen: ScreenObject {
	var app: XCUIApplication
	var searchTextField: XCUIElement { return app.textFields[AppConstants.A11y.searchTextField] }
	var searchClearButton: XCUIElement { return app.images[AppConstants.A11y.searchTextField] }
	var searchResultList: XCUIElement { return app.tables[AppConstants.A11y.searchResultList] }
	var emptyResultImage: XCUIElement { return app.images[AppConstants.A11y.searchEmptyResultContainer] }
	var emptyResultLabel: XCUIElement { return app.staticTexts[AppConstants.A11y.searchEmptyResultContainer] }
	var placesScrollView: XCUIElement { return app.scrollViews[AppConstants.A11y.placesScrollView] }
	var editPlacesButton: XCUIElement { return app.buttons[AppConstants.A11y.editPlacesButton] }

	init(_ application: XCUIApplication) {
		app = application
	}

	func tapSearchTextField() {
		searchTextField.tap()
	}

	func removeFirstPlace() {
		editPlacesButton.tap()
		_ = selectFirstPlace()
		editPlacesButton.tap()
	}

	func searchFor(place: String) {
		searchTextField.typeText(place)
	}

	func clearSearchTextField() {
		searchClearButton.tap()
	}

	func selectFirstPlaceFromSearch() -> WeatherScreen {
		tapSearchTextField()
		searchFor(place: "Athens")

		searchResultList.cells.element(boundBy: 0).tap()

		return WeatherScreen(app)
	}

	func selectFirstPlace() -> WeatherScreen {
		placesScrollView.otherElements.element(boundBy: 0).tap()

		return WeatherScreen(app)
	}
}
