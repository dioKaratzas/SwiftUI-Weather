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

// MARK: - Place
struct Place: Codable, Identifiable {
	let id = UUID()
	let name: String
	let country: String?
	let region: String?

	enum CodingKeys: String, CodingKey {
		case areaName, country, region
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		if let name = try container.decodeStringIfPresent(forKey: .areaName) {
			self.name = name
		} else {
			self.name = "Unknown"
		}

		country = try container.decodeStringIfPresent(forKey: .country)
		region = try container.decodeStringIfPresent(forKey: .region)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeStringIfPresent(name, forKey: .areaName)
		try container.encodeStringIfPresent(country, forKey: .country)
		try container.encodeStringIfPresent(region, forKey: .region)
	}
}

extension Place: Hashable {
	static func == (lhs: Place, rhs: Place) -> Bool {
		if lhs.name == rhs.name, lhs.region == rhs.region, lhs.region == rhs.region, lhs.country == rhs.country {
			return true
		}
		return false
	}
}
