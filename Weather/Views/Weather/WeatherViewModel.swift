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

import SwiftUI

class WeatherViewModel: ObservableObject {
	private let localWeather: LocalWeather?
	private let place: Place?
	
	private var currentWeather: CurrentWeather? {
		return localWeather?.currentWeather.first
	}

	// MARK: - Public properties
	var placeName: String {
		place?.name ?? ""
	}

	var hourSummaries: [Hourly] {
		guard let todayWeather = localWeather?.dailyWeather.first?.hourly else { return [] }

		if isRunningUITests {
			return todayWeather
		}

		// Filter the hourly weather elements that the current time have not passed
		return todayWeather.filter {
			guard let hourlyDate = Helpers.hourlyTimeToDate(timeFor(hourly: $0)) else { return false }
			let hourly = Calendar.current.component(.hour, from: hourlyDate)
			let now = Calendar.current.component(.hour, from: Date())

			return hourly > now
		}
	}

	var daySummaries: [WeatherElement] {
		localWeather?.dailyWeather ?? []
	}

	var currentTempDescription: String {
		currentWeather?.weatherDescription ?? ""
	}

	var currentWeatherIcon: Image? {
		guard let currentWeather = currentWeather else { return nil }

		return currentWeather.image(sunriseTime: sunriseTime, sunsetTime: sunsetTime)
	}

	var currentTemp: String {
		currentWeather?.tempFormatted ?? ""
	}

	var feelsLike: String {
		currentWeather?.feelsLikeFormatted ?? ""
	}

	var uvIndex: String {
		currentWeather?.uvIndexFormatted ?? ""
	}

	var humidity: String {
		currentWeather?.humidityFormatted ?? ""
	}

	var windSpeed: String {
		currentWeather?.windSpeedFormatted ?? ""
	}

	var windDirection: String {
		currentWeather?.windDirectionFormatted ?? ""
	}

	var sunriseTime: String {
		guard let astronomy = localWeather?.dailyWeather.first?.astronomy.first else { return "" }

		return astronomy.sunriseFormatted
	}

	var sunsetTime: String {
		guard let astronomy = localWeather?.dailyWeather.first?.astronomy.first else { return "" }

		return astronomy.sunsetFormatted
	}

	// MARK: - Constructor
	init(localWeather: LocalWeather?, place: Place?) {
		self.localWeather = localWeather
		self.place = place
	}

	// MARK: - Public Methods
	func tempFor(hourly: Hourly) -> String {
		return hourly.tempFormatted
	}

	func imageFor(hourly: Hourly) -> Image? {
		return hourly.image(sunriseTime: sunriseTime, sunsetTime: sunsetTime)
	}

	func timeFor(hourly: Hourly) -> String {
		return hourly.timeFormatted
	}

	func dayFor(weatherElement: WeatherElement) -> String {
		if let weather = daySummaries.first, weather.id == weatherElement.id {
			return "Today"
		}
		return weatherElement.day
	}

	func highTempFor(weatherElement: WeatherElement) -> String {
		return weatherElement.highTempFormatted
	}

	func lowTempFor(weatherElement: WeatherElement) -> String {
		return weatherElement.lowTempFormatted
	}

	func imageFor(weatherElement: WeatherElement) -> Image? {
		return weatherElement.image
	}
}
