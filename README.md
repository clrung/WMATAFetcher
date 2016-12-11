# WMATAFetcher ![language](https://img.shields.io/badge/Language-Swift-blue.svg) [![Version](https://img.shields.io/cocoapods/v/WMATAFetcher.svg?style=flat)](http://cocoapods.org/pods/WMATAFetcher) [![License](https://img.shields.io/cocoapods/l/WMATAFetcher.svg?style=flat)](http://cocoapods.org/pods/WMATAFetcher) [![Platform](https://img.shields.io/cocoapods/p/WMATAFetcher.svg?style=flat)](http://cocoapods.org/pods/WMATAFetcher)
## Description
A cross-platform [CocoaPod](https://cocoapods.org) that fetches information from [WMATA's API](https://developer.wmata.com/) and stores it in `Train` objects, which are modeled after the API's [AIMPredictionTrainInfo](https://developer.wmata.com/docs/services/547636a6f9182302184cda78/operations/547636a6f918230da855363f/console#AIMPredictionTrainInfo) object.

## Requirements
* iOS 8.0+
* macOS 10.9+
* tvOS 9.0+
* watchOS 2.0+

## Installation
WMATAFetcher is available via [CocoaPods](https://cocoapods.org). To install it, add the following to your `Podfile`:

```ruby
target 'TargetName' do
	pod 'WMATAFetcher'
end
```

Next, run the following in a Terminal:

```bash
$ pod install
```

## Usage
### Instantiation
First, create a new `WMATAFetcher` object, passing it your [WMATA API key](https://developer.wmata.com/signup/):

```Swift
var wmataFetcher = WMATAFetcher(WMATA_API_KEY: "[YOUR_WMATA_KEY]")
```

#### Spaces between groups
The `isSpaceInTrainArray` `BOOL` determines if a `Station.Space` object will separate each group in the `Train` array (default: `true`).

You may initialize this value when instantiating a new `WMATAFetcher` object:

```Swift
var wmataFetcher = WMATAFetcher(WMATA_API_KEY: "[YOUR_WMATA_KEY]", isSpaceInTrainArray: false)
```

You may also change the value of `isSpaceInTrainArray` directly:

```Swift
wmataFetcher.isSpaceInTrainArray = false
```

### Fetching
Pass `wmataFetcher.getStationPredictions` a station code to get predictions.  Implement `onCompleted` to handle the `TrainResponse` returned.

If `trainResponse.errorCode` is `nil`, we can safely force upwrap `trainResponse.trains?`.

```Swift
let wmataFetcher = WMATAFetcher(WMATA_API_KEY: "[API KEY HERE]")

let metroCenterStationCode = Station(description: "Metro Center")!.rawValue

wmataFetcher.getStationPredictions(stationCode: metroCenterStationCode, onCompleted: {
	trainResponse in
	if trainResponse.errorCode == nil {
		for train in trainResponse.trains! {
			print(train.debugDescription);
		}
	} else {
		switch trainResponse.errorCode! {
		case -1009:
			print("Internet connection is offline")
		default:
			print("Prediction fetch failed (Code: \(trainResponse.errorCode!))")
	}
})
```

### Error Handling
`TrainResponse.errorCode` is an `Int?` representing the [HTTP status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) returned by WMATA's API.  If it is `nil`, the fetch was successful.  The most common error codes are:

1. -1009 
 * The internet connection is offline
1. 401
 * Unauthorized.  This is likely a bad WMATA key.

## Dependencies
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

## Notable Projects
* [DC Metro Widget](https://github.com/clrung/DCMetroWidget)
 * Today extension for macOS' Notification Center
 * Inspiration for this `Pod`

<p align="center">
<a href="http://appstore.com/mac/dcmetro"><img src="https://www.mapdiva.com/wp-content/uploads/2011/01/Mac_App_Store_Badge_US_UK1.png" width="400" height="200" alt="Available on the Mac App Store"/></a>

<img src="https://raw.githubusercontent.com/clrung/DCMetroWidget/master/Screenshots/GitHub/Main.png" width="331"/>
</p>

## License
WMATAFetcher is available under the MIT license. See the LICENSE file for more info.
