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

#if DEBUG
import Combine
import Foundation

class WeatherServiceMock: WeatherService {
	private let weatherLocalRepository = WeatherLocalRepository()
	func loadPlaces() -> AnyPublisher<[Place], Never> {
		if isRunningUITests {
			return weatherLocalRepository.loadPlaces()
		}
		return Just(createPlacesResponseMock())
			.receive(on: DispatchQueue.main)
			.map {
				$0.searchAPI.result
			}
			.eraseToAnyPublisher()
	}

	func savePlaces(places: [Place]) -> AnyPublisher<Void, Never> {
		if isRunningUITests {
			return weatherLocalRepository.savePlaces(places: places)
		}
		return Just(createWeatherResponseMock())
			.receive(on: DispatchQueue.main)
			.map { _ in 
			}
			.eraseToAnyPublisher()
	}

	func search(for location: String) -> AnyPublisher<[Place], WeatherApiError> {
		return Just(createPlacesResponseMock())
			.receive(on: DispatchQueue.main)
			.map {
				$0.searchAPI.result
			}
			.setFailureType(to: WeatherApiError.self)
			.eraseToAnyPublisher()
	}

	func fetchWeather(for place: Place) -> AnyPublisher<LocalWeather, WeatherApiError> {
		return Just(createWeatherResponseMock())
			.receive(on: DispatchQueue.main)
			.map {
				$0.data
			}
			.setFailureType(to: WeatherApiError.self)
			.eraseToAnyPublisher()
	}

	// swiftlint:disable force_try force_unwrapping
	func createPlacesResponseMock() -> PlacesResponce {
		let path = Bundle.main.path(forResource: "SearchLocationsResponse", ofType: "json")!
		let url = URL(fileURLWithPath: path)
		let data = try! Data(contentsOf: url)
		let response = try! JSONDecoder().decode(PlacesResponce.self, from: data)
		return response
	}

	func createWeatherResponseMock() -> WeatherResponse {
		let path = Bundle.main.path(forResource: "WeatherResponse", ofType: "json")!
		let url = URL(fileURLWithPath: path)
		let data = try! Data(contentsOf: url)
		let response = try! JSONDecoder().decode(WeatherResponse.self, from: data)
		return response
	}
	// swiftlint:enable force_try force_unwrapping
}
#endif
