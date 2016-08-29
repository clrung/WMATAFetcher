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

```obj-c
var WMATAfetcher = WMATAFetcher(WMATA_API_KEY: "[YOUR_WMATA_KEY]")
```

#### Spaces between groups
The `isSpaceInTrainArray` `BOOL` determines if a `Station.Space` object will separate each group in the `Train` array (default: `true`).

You may initialize this value when creating a new `WMATAFetcher` object:

```obj-c
var WMATAfetcher = WMATAFetcher(WMATA_API_KEY: "[YOUR_WMATA_KEY]", isSpaceInTrainArray: false)
```

You may also change the value of `isSpaceInTrainArray` directly:

```obj-c
WMATAfetcher.isSpaceInTrainArray = false
```

### Fetching
Pass `WMATAfetcher` a station code to get predictions.  Implement `onCompleted` to handle the `TrainResponse` returned by `getPrediction()`.

```obj-c
String stationCode = Station(description: "Metro Center")!.rawValue
WMATAfetcher.getPrediction(stationCode, onCompleted: {
trainResponse in
	if trainResponse.error == nil {
		self.trains = trainResponse.trains!
	} else {
		// handle fetch error
	}
})
```

### Error Handling
`TrainResponse.error` is a `String?` that has three possible values:

1. `nil`
 * Fetch was successful
1. "Internet connection is offline"
1. "Prediction fetch failed (Code: [HTTP STATUS CODE])"
 * If the status code returned by the request is not 200 (success), this error will be thrown.  It can be any [HTTP status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes), but will most likely be a [401 (Unauthorized)](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#4xx_Client_Error) error, caused by an invalid WMATA API key.

Use these values to notify your user about the error.

## Dependencies
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

## Notable Projects
* [DC Metro Widget](https://github.com/clrung/DCMetroWidget)
 * Today extension for macOS' Notification Center
 * Inspiration for this `Pod`

## License
WMATAFetcher is available under the MIT license. See the LICENSE file for more info.