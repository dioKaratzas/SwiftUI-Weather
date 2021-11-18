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

// swiftlint:disable all
@testable import Weather
import XCTest
import Combine

class WeatherViewModelTests: XCTestCase {
	var viewModel: WeatherViewModel!

	override func setUpWithError() throws {
		let place = WeatherServiceMock().createPlacesResponseMock().searchAPI.result.first!
		let weather = WeatherServiceMock().createWeatherResponseMock().data
		viewModel = WeatherViewModel(localWeather: weather, place: place)
	}

	func testWeatherViewModelData() {
		XCTAssertEqual(viewModel.placeName, "Athens")
		XCTAssertEqual(viewModel.daySummaries.count, 5)
		XCTAssertEqual(viewModel.currentTempDescription, "Partly cloudy")
		XCTAssertNotNil(viewModel.currentWeatherIcon)
		XCTAssertEqual(viewModel.currentTemp, "16º")
		XCTAssertEqual(viewModel.feelsLike, "16º")
		XCTAssertEqual(viewModel.uvIndex, "4")
		XCTAssertEqual(viewModel.humidity, "59%")
		XCTAssertEqual(viewModel.windSpeed, "31km/h")
		XCTAssertEqual(viewModel.windDirection, "N")
		XCTAssertEqual(viewModel.sunriseTime, "7:07 AM")
		XCTAssertEqual(viewModel.sunsetTime, "5:13 PM")

		let weatherElement = viewModel.daySummaries.first!

		XCTAssertEqual(viewModel.dayFor(weatherElement: weatherElement), "Today")
		XCTAssertNotNil(viewModel.imageFor(weatherElement: weatherElement))
		XCTAssertEqual(viewModel.highTempFor(weatherElement: weatherElement), "16º")
		XCTAssertEqual(viewModel.lowTempFor(weatherElement: weatherElement), "12º")
	}
}
