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
import Swinject

@propertyWrapper
struct Inject<Component> {
	let wrappedValue: Component
	init() {
		self.wrappedValue = Resolver.shared.resolve(Component.self)
	}
}

// swiftlint:disable force_unwrapping
class Resolver {
	static let shared = Resolver()
	private var container = buildContainer()

	func resolve<T>(_ type: T.Type) -> T {
		container.resolve(T.self)!
	}

	func setDependencyContainer(_ container: Container) {
		self.container = container
	}
}

private func buildContainer() -> Container {
	let container = Container()

	if isRunningUITests {
		container.register(WeatherService.self) { _ in
			WeatherServiceMock()
		}
		.inObjectScope(.container)
	} else {
		container.register(WeatherService.self) { _ in
			WeatherServiceImpl(weatherWebRepository: WeatherWebRepository(), weatherLocalRepository: WeatherLocalRepository())
		}
		.inObjectScope(.container)
	}

	container.register(MainViewModel.self) { resolver  in
		MainViewModel(weatherService: resolver.resolve(WeatherService.self)!)
	}
	.inObjectScope(.container)

	container.register(WeatherViewModel.self) { resolver  in
		let mainViewModel = resolver.resolve(MainViewModel.self)!
		return WeatherViewModel(localWeather: mainViewModel.localWeather, place: mainViewModel.selectedPlace)
	}
	.inObjectScope(.transient)

	return container
}

func buildMockContainer() -> Container {
	let container = Container()

	container.register(WeatherService.self) { _  in
		WeatherServiceMock()
	}
	.inObjectScope(.container)

	container.register(MainViewModel.self) { resolver  in
		MainViewModelMock(weatherService: resolver.resolve(WeatherService.self)!)
	}
	.inObjectScope(.container)

	container.register(WeatherViewModel.self) { _  in
		return WeatherViewModelMock()
	}
	.inObjectScope(.container)

	return container
}
// swiftlint:enable force_unwrapping
