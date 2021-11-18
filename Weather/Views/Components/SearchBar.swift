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

struct SearchBar: View {
	@Binding var searchText: String
	@State var showClearButton = false
	var placeholder = "Search"

	var body: some View {
		TextField(placeholder, text: $searchText, onEditingChanged: { editing in
			self.showClearButton = editing
		}, onCommit: {
			self.showClearButton = false
		})
			.modifier(ClearButton(text: $searchText, isVisible: $showClearButton))
			.padding(.horizontal)
			.padding(.vertical, 10)
			.background(Color(.secondarySystemBackground))
			.cornerRadius(12)
			.accessibilityIdentifier(AppConstants.A11y.searchTextField)
	}
}

struct ClearButton: ViewModifier {
	@Binding var text: String
	@Binding var isVisible: Bool

	func body(content: Content) -> some View {
		HStack {
			content
			Spacer()
			Image(systemName: "xmark.circle.fill")
				.foregroundColor(Color(.placeholderText))
				.opacity(!text.isEmpty ? 1 : 0)
				.opacity(isVisible ? 1 : 0)
				.onTapGesture { self.text = "" }
				.accessibilityIdentifier(AppConstants.A11y.searchTextField)
		}
	}
}

struct SearchBar_Previews: PreviewProvider {
	static var previews: some View {
		SearchBar(searchText: .constant(""))
	}
}
