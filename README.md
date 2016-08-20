# WMATAFetcher [![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/clrung/WMATAFetcher/master/LICENSE) [![platforms](https://img.shields.io/cocoapods/p/AFNetworking.svg)]()
## Description
A cross-platform [CocoaPod](https://cocoapods.org) that fetches information from [WMATA's API](https://developer.wmata.com/) and stores it in Train objects, which are modeled after the API's [AIMPredictionTrainInfo](https://developer.wmata.com/docs/services/547636a6f9182302184cda78/operations/547636a6f918230da855363f/console#AIMPredictionTrainInfo) object.

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
By default, a `Station.Space` object is placed in the `Train` array to separate the groups.  If you do not want this space in the `Train` array, use 

```obj-c
var WMATAfetcher = WMATAFetcher(WMATA_API_KEY: "[YOUR_WMATA_KEY]", trainArrayShouldIncludeSpaces: false)
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