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

import SimpleToast
import SwiftUI

struct MainView: View {
	@StateObject private var viewModel: MainViewModel = Resolver.shared.resolve(MainViewModel.self)

	var body: some View {
		NavigationView {
			ZStack {
				BackgroundView()

				VStack {
					headerView

					SearchBar(searchText: $viewModel.searchText, placeholder: L10n.searchLocationPlaceholder)
						.padding()

					if viewModel.searchText.isEmpty {
						placesListView
					} else {
						searchPlacesListView
					}

					Spacer()
				}
				.simpleToast(isPresented: $viewModel.showToast, options: viewModel.toastOptions) {
					HStack {
						Image(systemName: "exclamationmark.triangle")
						Text(viewModel.toastMessage)
					}
					.padding()
					.background(Color.red.opacity(0.8))
					.foregroundColor(Color.white)
					.cornerRadius(10)
					.offset(x: 0, y: -20)
				}
				.sheet(isPresented: $viewModel.weatherViewSheetPresented) {
					WeatherView(isSheet: true, canSave: !viewModel.currentPlaceIsSaved) {
						viewModel.saveSelectedPlace()
					}
				}
			}
			.navigationBarHidden(true)
			.background(Color.clear)
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}

	private var placesListView: some View {
		return AnyView(
			ScrollView(showsIndicators: false) {
				ForEach(viewModel.weathersData) { weatherData in
					ZStack {
						NavigationLink(destination: WeatherView(isSheet: false, canSave: false), isActive: $viewModel.weatherViewPresented) { EmptyView() }
						.frame(width: 0, height: 0)
						.hidden()

						HStack {
							if viewModel.state == .editingPlaces {
								Button(action: {
									viewModel.removeWeatherDate(weatherData)
								}, label: {
									Image(systemName: "minus.circle.fill")
										.foregroundColor(WeatherColor.AccentColor)
								})
									.accessibilityIdentifier(AppConstants.A11y.removePlaceButton)
							}
							HStack {
								VStack(alignment: .leading) {
									Text(weatherData.placeName)
										.fontWeight(.medium)
									Spacer()
									Text(weatherData.currentTempDescription)
										.font(Font.system(size: 12))
										.foregroundColor(.secondary)
								}
								Spacer()
								if viewModel.state == .fetchingWeathersData {
									ProgressView()
								} else {
									Text(weatherData.currentTemp)
										.fontWeight(.light)
									weatherData.image?
										.renderingMode(.original)
										.imageScale(.large)
								}
							}
							.padding()
							.background(Color(.secondarySystemBackground))
							.cornerRadius(10)
							.onTapGesture {
								if viewModel.state == .editingPlaces {
									viewModel.removeWeatherDate(weatherData)
								} else {
									viewModel.selectedPlace = weatherData.place
								}
							}
						}
					}
					.animation(Animation.default)
				}
			}
				.padding()
				.accessibilityIdentifier(AppConstants.A11y.placesScrollView)
		)
	}

	private var searchPlacesListView: some View {
		return AnyView(
			ZStack {
				if viewModel.state == .loadingPlaces {
					ProgressView()
				} else if !viewModel.searchResults.isEmpty {
					List(viewModel.searchResults) { place in
						HStack {
							Button("\(place.name), \(place.region ?? ""), \(place.country ?? "")") {
								viewModel.selectedPlace = place
							}
							.buttonStyle(PlainButtonStyle())

							if case let .fethcingWeatherForPlace(placeLoading) = viewModel.state, placeLoading == place {
								Spacer()
								ProgressView()
							}
						}
					}
					.onAppear {
						UITableView.appearance().backgroundColor = UIColor.clear
						UITableViewCell.appearance().backgroundColor = UIColor.clear
					}
					.offset(x: 0, y: -20)
					.accessibilityIdentifier(AppConstants.A11y.searchResultList)
				} else {
					VStack {
						Image(systemName: "magnifyingglass")
							.font(.title)
						Text(L10n.noSearchResults)
							.font(.title2)
					}
					.accessibilityIdentifier(AppConstants.A11y.searchEmptyResultContainer)
				}
			}
		)
	}

	private var headerView: some View {
		return AnyView(
			ZStack {
				HStack {
					Spacer()
				}
				VStack {
					Text(L10n.weatherTitle)
						.font(.system(size: 22, weight: .regular))
				}
				HStack {
					Spacer()
					if (viewModel.canEditPlaces || viewModel.state == .editingPlaces) && viewModel.searchText.isEmpty {
						Button(action: {
							if viewModel.state == .editingPlaces {
								viewModel.doneEditingPlaces()
							} else {
								viewModel.editPlaces()
							}
						}, label: {
							if viewModel.state == .editingPlaces {
								Text(L10n.done)
							} else {
								Image(systemName: "pencil.circle")
									.font(.system(size: 22, weight: .regular))
							}
						}).accessibilityIdentifier(AppConstants.A11y.editPlacesButton)
					}
				}
			}.padding()
		)
	}
}

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		Resolver.shared.setDependencyContainer(buildMockContainer())
		return MainView()
	}
}
