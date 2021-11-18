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

class WeatherWebRepository {
	let session: URLSession

	// Make the session shared by default.
	// In unit tests, a mock session can be injected.
	init(urlSession: URLSession = .shared) {
		self.session = urlSession
	}

	func fetchWeather(location: String) -> AnyPublisher<LocalWeather, WeatherApiError> {
		let endpoint = Api.fetchWeather(location: location)

		return session
			.dataTaskPublisher(for: endpoint.urlRequest)
			.receive(on: DispatchQueue.main)
			.mapError { error in
				WeatherApiError.errorCode(error.errorCode)
			}
			.flatMap { data, response -> AnyPublisher<LocalWeather, WeatherApiError> in
				guard let response = response as? HTTPURLResponse else {
					return Fail(error: WeatherApiError.unknown).eraseToAnyPublisher()
				}
				if (200...299).contains(response.statusCode) {
					let jsonDecoder = JSONDecoder()
					jsonDecoder.dateDecodingStrategy = .iso8601
					return Just(data)
						.decode(type: WeatherResponse.self, decoder: jsonDecoder)
						.mapError { _ in
							return WeatherApiError.decodingError
						}
						.map { $0.data }
						.eraseToAnyPublisher()
				} else {
					return Fail(error: WeatherApiError.errorCode(response.statusCode)).eraseToAnyPublisher()
				}
			}
			.eraseToAnyPublisher()
	}

	func searchLocation(location: String) -> AnyPublisher<[Place], WeatherApiError> {
		let endpoint = Api.searchLocation(location: location)

		return session
			.dataTaskPublisher(for: endpoint.urlRequest)
			.receive(on: DispatchQueue.main)
			.mapError { error in
				WeatherApiError.errorCode(error.errorCode)
			}
			.flatMap { data, response -> AnyPublisher<[Place], WeatherApiError> in
				guard let response = response as? HTTPURLResponse else {
					return Fail(error: WeatherApiError.unknown).eraseToAnyPublisher()
				}
				if (200...299).contains(response.statusCode) {
					let jsonDecoder = JSONDecoder()
					jsonDecoder.dateDecodingStrategy = .iso8601
					return Just(data)
						.decode(type: PlacesResponce.self, decoder: jsonDecoder)
						.mapError { error in
							logger.error("Decode failed: \(error)\nData result: \(String(describing: String(data: data, encoding: String.Encoding.utf8)))")
							return WeatherApiError.decodingError
						}
						.map { $0.searchAPI.result }
						.eraseToAnyPublisher()
				} else {
					return Fail(error: WeatherApiError.errorCode(response.statusCode)).eraseToAnyPublisher()
				}
			}
			.eraseToAnyPublisher()
	}
}

private enum Api {
	case searchLocation(location: String)
	case fetchWeather(location: String)

	private static let sharedQuery: [AppConstants.Api.QueryKey: String] = [.apiKey: AppConstants.Api.apiKey, .format: "json"]

	private var baseURL: URL {
		switch self {
			case .searchLocation, .fetchWeather:
				return AppConstants.Api.apiUrl
		}
	}

	private var path: String {
		switch self {
			case .searchLocation:
				return "/search.ashx"
			case .fetchWeather:
				return "/weather.ashx"
		}
	}

	private var params: [AppConstants.Api.QueryKey: String] {
		switch self {
			case .searchLocation(let location):
				var params: [AppConstants.Api.QueryKey: String] = Api.sharedQuery
				params[.searchString] = location.replacingOccurrences(of: " ", with: "+")
				return params
			case .fetchWeather(let location):
				var params: [AppConstants.Api.QueryKey: String] = Api.sharedQuery
				params[.searchString] = location.replacingOccurrences(of: " ", with: "+")
				let weatherParams: [AppConstants.Api.QueryKey: String] = [
					.comments: AppConstants.Api.QueryValue.comments,
					.numOfDays: AppConstants.Api.QueryValue.numOfDays,
					.forcast: AppConstants.Api.QueryValue.forcast,
					.currentCondition: AppConstants.Api.QueryValue.currentCondition,
					.monthlyCondition: AppConstants.Api.QueryValue.monthlyCondition,
					.location: AppConstants.Api.QueryValue.location,
					.tp: AppConstants.Api.QueryValue.tp,
				]

				params.merge(weatherParams) { current, _ in current }
				return params
		}
	}

	var urlRequest: URLRequest {
		switch self {
			case .searchLocation, .fetchWeather:
				guard let url = baseURL.appendingPathComponent(path).appendingParams(params: params) else { fatalError("Failed to construct url") }
				return URLRequest(url: url)
		}
	}
}

private extension URL {
	func appendingParams(params: [AppConstants.Api.QueryKey: String]) -> URL? {
		var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
		components?.queryItems = params.map { element in URLQueryItem(name: element.key.rawValue, value: element.value) }

		return components?.url
	}
}
