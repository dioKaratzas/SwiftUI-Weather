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

import Combine
import Foundation

protocol WeatherService {
	func search(for location: String) -> AnyPublisher<[Place], WeatherApiError>
	func fetchWeather(for place: Place) -> AnyPublisher<LocalWeather, WeatherApiError>
	func loadPlaces() -> AnyPublisher<[Place], Never>
	func savePlaces(places: [Place]) -> AnyPublisher<Void, Never>
}

struct WeatherServiceImpl: WeatherService {
	private var weatherWebRepository: WeatherWebRepository
	private var weatherLocalRepository: WeatherLocalRepository

	init(weatherWebRepository: WeatherWebRepository, weatherLocalRepository: WeatherLocalRepository) {
		self.weatherWebRepository = weatherWebRepository
		self.weatherLocalRepository = weatherLocalRepository
	}

	func fetchWeather(for place: Place) -> AnyPublisher<LocalWeather, WeatherApiError> {
		return weatherWebRepository.fetchWeather(location: "\(place.name), \(place.region ?? ""), \(place.country ?? "")")
	}

	func search(for location: String) -> AnyPublisher<[Place], WeatherApiError> {
		return weatherWebRepository.searchLocation(location: location)
	}

	func loadPlaces() -> AnyPublisher<[Place], Never> {
		return weatherLocalRepository.loadPlaces()
	}

	func savePlaces(places: [Place]) -> AnyPublisher<Void, Never> {
		return weatherLocalRepository.savePlaces(places: places)
	}
}
