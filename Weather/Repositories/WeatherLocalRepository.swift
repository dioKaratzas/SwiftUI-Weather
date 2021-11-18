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

class WeatherLocalRepository {
	private static var documentsFolder: URL {
		do {
			return try FileManager.default.url(for: .documentDirectory,
												  in: .userDomainMask,
												  appropriateFor: nil,
												  create: false)
		} catch {
			fatalError("Can't find documents directory.")
		}
	}
	private static var fileURL: URL {
		return documentsFolder.appendingPathComponent("places.data")
	}

	init() {
		if isRunningUITests {
			do {
				try FileManager.default.removeItem(at: WeatherLocalRepository.fileURL)
				logger.trace("File deleted")
			} catch {
				logger.error("\(error)")
			}
		}
	}

	func loadPlaces() -> AnyPublisher<[Place], Never> {
		return Future { promise in
			DispatchQueue.global(qos: .background).async {
				guard let data = try? Data(contentsOf: Self.fileURL) else {
					return
				}
				guard let places = try? JSONDecoder().decode([Place].self, from: data) else {
					fatalError("Can't decode saved data.")
				}
				promise(.success(places))
			}
		}
		.receive(on: DispatchQueue.main)
		.eraseToAnyPublisher()
	}

	func savePlaces(places: [Place]) -> AnyPublisher<Void, Never> {
		return Future { promise in
			DispatchQueue.global(qos: .background).async {
				guard let data = try? JSONEncoder().encode(places) else { fatalError("Error encoding data") }
				do {
					let outfile = Self.fileURL
					try data.write(to: outfile)
					promise(.success(()))
				} catch {
					fatalError("Can't write to file")
				}
			}
		}
		.receive(on: DispatchQueue.main)
		.eraseToAnyPublisher()
	}
}
