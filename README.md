# SwiftUI-Weather

The SwiftUI Weather app, allow users get the current weather for a particular locatio and view a 5-day weather forecast for the selected place. Powered by World Weather Online API.
 
### Screenshots

<img src="./res/screen1.png" alt="screen1" height="600" /> <img src="./res/screen2.png" alt="screen2" height="600" />

### Features
* Add and remove a place.
* Place list is persisted localy
* Share the item details with others
* Display the hourly weather forecast for each day

## How to Work with the Source

* In order to get Weather app to work, you need to put your [worldweatheronline](https://www.worldweatheronline.com) secret key on the AppConstants.swift file 
```AppConstants.swift
static let apiKey = "Your world weather online API key"
```


Libraries
---------
* [Swift Log](https://github.com/apple/swift-log.git)
* [Swinject](https://github.com/Swinject/Swinject.git)
* [Simple Toast](https://github.com/sanzaru/SimpleToast.git)
* [SwiftList](https://github.com/realm/SwiftLint)
* [SwiftGen](https://github.com/SwiftGen/SwiftGen)

License
-------
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
