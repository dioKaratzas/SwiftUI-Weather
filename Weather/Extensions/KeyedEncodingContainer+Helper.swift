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

extension KeyedEncodingContainer {
	mutating func encodeStringIfPresent(_ value: String?, forKey key: KeyedEncodingContainer<K>.Key) throws {
		if let text = value {
			let dict = ["value": text]
			let list = [dict]
			try self.encode(list, forKey: key)
		}
	}

	mutating func encodeDoubleIfPresent(_ value: Double?, forKey key: KeyedEncodingContainer<K>.Key) throws {
		if let text = value {
			try self.encode(String(text), forKey: key)
		}
	}

	mutating func encodeIntIfPresent(_ value: Int?, forKey key: KeyedEncodingContainer<K>.Key) throws {
		if let text = value {
			try self.encode(String(text), forKey: key)
		}
	}
}
