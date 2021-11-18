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

import Foundation

// swiftlint:disable force_unwrapping
enum AppConstants {
	enum Api {
		static let apiUrl = URL(string: "https://api.worldweatheronline.com/premium/v1")!
		static let apiKey = "Your world weather online API key"

		enum QueryKey: String {
			case apiKey = "key"
			case searchString = "q"
			case format = "format"

			// Weather Query
			case numOfDays = "num_of_days"
			case forcast = "fx"
			case currentCondition = "cc"
			case monthlyCondition = "mca"
			case location = "includelocation"
			case comments = "show_comments"
			case tp = "tp"
		}

		enum QueryValue {
			static let numOfDays = "5"
			static let forcast = "yes"
			static let currentCondition = "yes"
			static let monthlyCondition = "no"
			static let location = "no"
			static let comments = "no"
			static let tp = "1"
		}
	}

	enum A11y {
		static let searchTextField = "searchTextField"
		static let searchResultList = "searchResultList"
		static let searchEmptyResultContainer = "searchEmptyResultContainer"

		static let weatherAddButton = "weatherAddButton"
		static let weatherCancelButton = "weatherCancelButton"
		static let weatherDismissButton = "weatherDismissButton"

		static let placesScrollView = "placesScrollView"
		static let removePlaceButton = "removePlaceButton"
		static let editPlacesButton = "editPlacesButton"
	}
}
// swiftlint:enable force_unwrapping
