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

class WeatherUITest: XCTestCase {
	var app = XCUIApplication()

	let timeOut = 10

	override func setUp() {
		super.setUp()
		continueAfterFailure = false

		app.launchArguments = ["isRunningUITests"]
		app.launch()
	}

	override func tearDown() {
		super.tearDown()
	}

	func waitUntilExists(forElement: XCUIElement, testCase: WeatherUITest) {

		let predicate = NSPredicate(format: "exists == true")
		testCase.expectation(for: predicate, evaluatedWith: forElement, handler: nil)

		testCase.waitForExpectations(timeout: TimeInterval(timeOut))
	}
}
