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

@testable import Weather
import XCTest

// swiftlint:disable force_unwrapping
class PlacesSearchTests: XCTestCase {
	func testPlacesSearchResult() {
		let jsonData = Bundle.stubbedDataFromJson(filename: "SearchResults")
		let decoder = JSONDecoder()
		do {
			let result = try decoder.decode(PlacesResponce.self, from: jsonData)
			XCTAssertEqual(result.searchAPI.result.count, 4)
		} catch {
			XCTAssert(false, "SearchResults.json decode failed \(error)")
		}
	}

	func testPlacesSearchResultEmpty() {
		let jsonData = Bundle.stubbedDataFromJson(filename: "SearchResultsEmpty")
		let decoder = JSONDecoder()
		do {
			let result = try decoder.decode(PlacesResponce.self, from: jsonData)
			XCTAssert(result.searchAPI.result.isEmpty)
		} catch {
			XCTAssert(false, "SearchResultsEmpty.json decode failed \(error)")
		}
	}

	func testPlacesSearchResultInvalidJson() {
		let jsonData = "{\"data1\"\"\"}".data(using: .utf8)!
		let decoder = JSONDecoder()
		do {
			let result = try decoder.decode(PlacesResponce.self, from: jsonData)
			XCTAssert(false, "Should fail \(result)")
		} catch _ as DecodingError {
			XCTAssert(true)
		} catch {
			XCTAssert(false, "should throw DecodingError \(error)")
		}
	}
}
// swiftlint:enable force_unwrapping
