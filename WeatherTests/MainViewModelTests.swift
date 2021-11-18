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

class MainViewModelTests: XCTestCase {
	private var cancellables = Set<AnyCancellable>()
	var place: Place!

	override func setUpWithError() throws {
		place = try! JSONDecoder().decode(Place.self, from: Bundle.stubbedDataFromJson(filename: "Place"))
	}

	func testSearchResults() {
		let viewModel = MainViewModel(weatherService: WeatherServiceMock())
		viewModel.searchText = "Test"

		let expectation = XCTestExpectation(description: "searchResults")

		viewModel.$searchResults
			.sink(receiveValue: { places in
				if places.count == 4 {
					expectation.fulfill()
				}
			})
			.store(in: &cancellables)

		wait(for: [expectation], timeout: 10)
	}

	func testSelectedPlace() {
		let viewModel = MainViewModel(weatherService: WeatherServiceMock())
		viewModel.selectedPlace = place

		let expectation = XCTestExpectation(description: "searchResults")

		XCTAssertEqual(viewModel.state, .fethcingWeatherForPlace(place: place))

		viewModel.$localWeather
			.sink(receiveValue: { localWeather in
				if localWeather != nil {
					expectation.fulfill()
				}
			})
			.store(in: &cancellables)

		wait(for: [expectation], timeout: 10)

		XCTAssertEqual(viewModel.state, .none)
		XCTAssertTrue(viewModel.weatherViewPresented)
		XCTAssertFalse(viewModel.weatherViewSheetPresented)

	}

	func testSelectedPlaceFromSearch() {
		let viewModel = MainViewModel(weatherService: WeatherServiceMock())
		viewModel.searchText = "Test"
		viewModel.selectedPlace = place

		let expectation = XCTestExpectation(description: "searchResults")

		XCTAssertEqual(viewModel.state, .fethcingWeatherForPlace(place: place))

		viewModel.$localWeather
			.sink(receiveValue: { localWeather in
				if localWeather != nil {
					expectation.fulfill()
				}
			})
			.store(in: &cancellables)

		wait(for: [expectation], timeout: 10)

		XCTAssertEqual(viewModel.state, .none)
		XCTAssertTrue(viewModel.weatherViewSheetPresented)
		XCTAssertFalse(viewModel.weatherViewPresented)
	}

	func testSaveSelectedPlace() {
		let viewModel = MainViewModel(weatherService: WeatherServiceMock())
		viewModel.searchText = "Test"
		removeSavedItems(viewModel: viewModel)

		viewModel.selectedPlace = place

		XCTAssertEqual(viewModel.weathersData.count, 0)
		XCTAssertNil(viewModel.localWeather)

		viewModel.saveSelectedPlace()

		XCTAssertEqual(viewModel.weathersData.count, 1)
		XCTAssertTrue(viewModel.searchText.isEmpty)

		let expectation = XCTestExpectation(description: "featchWeather")

		viewModel.$localWeather
			.sink(receiveValue: { localWeather in
				if localWeather != nil {
					expectation.fulfill()
				}
			})
			.store(in: &cancellables)

		wait(for: [expectation], timeout: 10)
	}

	func testEditPlaces() {
		let viewModel = MainViewModel(weatherService: WeatherServiceMock())
		removeSavedItems(viewModel: viewModel)

		viewModel.selectedPlace = place
		viewModel.saveSelectedPlace()

		viewModel.editPlaces()

		XCTAssertEqual(viewModel.state, .editingPlaces)

		viewModel.removeWeatherDate(viewModel.weathersData.first!)

		XCTAssertTrue(viewModel.weathersData.isEmpty)

		viewModel.doneEditingPlaces()

		XCTAssertEqual(viewModel.state, .none)
	}

	func testCanEditPlaces() {
		let viewModel = MainViewModel(weatherService: WeatherServiceMock())
		removeSavedItems(viewModel: viewModel)

		XCTAssertFalse(viewModel.canEditPlaces)

		viewModel.selectedPlace = place
		viewModel.saveSelectedPlace()

		XCTAssertTrue(viewModel.canEditPlaces)
	}

	func testWeatherData() {
		let viewModel = MainViewModel(weatherService: WeatherServiceMock())
		removeSavedItems(viewModel: viewModel)
		viewModel.selectedPlace = place
		viewModel.saveSelectedPlace()

		let data = viewModel.weathersData.first!
		data.weather = WeatherServiceMock().createWeatherResponseMock().data

		XCTAssertEqual(data.placeName, "Athens - Attica")
		XCTAssertEqual(data.currentTemp, "16º")
		XCTAssertEqual(data.currentTempDescription, "Partly cloudy")
		XCTAssertNotNil(data.image)
		XCTAssertEqual(data.sunriseTime, "7:07 AM")
		XCTAssertEqual(data.sunsetTime, "5:13 PM")
	}

	private func removeSavedItems(viewModel: MainViewModel) {
		for data in viewModel.weathersData {
			viewModel.removeWeatherDate(data)
			viewModel.doneEditingPlaces()
		}
	}
}
// swiftlint:enable all
