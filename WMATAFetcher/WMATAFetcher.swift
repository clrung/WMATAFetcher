//
//  WMATAFetcher.swift
//
//  Copyright © 2016 Christopher Rung
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import SwiftyJSON
import CoreLocation

/// Fetches predictions from the [WMATA API](https://developer.wmata.com/), parses them with [SwiftyJSON](), and stores them in an array of [Train](https://github.com/clrung/WMATAFetcher/blob/master/WMATAFetcher/Train.swift) objects, which contain all relevant information about a Metro train.
open class WMATAFetcher {
	
	/// The start of the URL used to make the call to the WMATA API.  The station code to fetch will proceed this.
	fileprivate var WMATA_PREDICTION_BASE_URL = "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/"
	
	/// The developer's WMATA API key.  Get a free key after you [create an account](https://developer.wmata.com/signup/).
	fileprivate var WMATA_API_KEY: String
	
	/// Two seconds before the time the WMATAFetcher is instantiated.  Used to prevent repeated calls to the WMATA API.
	fileprivate var timeBefore: Date = Date(timeIntervalSinceNow: TimeInterval(-2))
	
	/// If true, the Train array will include spaces between each group.
	open var isSpaceInTrainArray: Bool

	/// The default constructor.  Creates a WMATAFetcher, provided a WMATA API key is supplied, and includes spaces between groups.
	///
	/// - Parameter WMATA_API_KEY: the developer's WMATA API key
	public required init(WMATA_API_KEY: String) {
		self.WMATA_API_KEY = WMATA_API_KEY
		self.isSpaceInTrainArray = true
	}
	
	/// Creates a WMATAFetcher, provided a WMATA API key is supplied.
	///
	/// - Parameters:
	///   - WMATA_API_KEY: the developer's WMATA API key
	///   - isSpaceInTrainArray: if true, spaces will separate each group in the trains array.
	public required init(WMATA_API_KEY: String, isSpaceInTrainArray: Bool) {
		self.WMATA_API_KEY = WMATA_API_KEY
		self.isSpaceInTrainArray = isSpaceInTrainArray
	}
	
	/// Determines the Metro predictions for the station code, including the second level predictions for stations that have two levels (Gallery Place, Fort Totten, L'Enfant Plaza, and Metro Center)
	///
	/// - Parameters:
	///   - stationCode: the three digit station code
	///   - onCompleted: the completion handler
	///   - result: the TrainResponse
	open func getStationPredictions(stationCode: String, onCompleted: @escaping (_ result: TrainResponse) -> ()) {
		let timeAfter = Date()
		
		// only fetch new predictions if it has been at least one second since they were last fetched
		if timeAfter.timeIntervalSince(timeBefore) > 1 {
			timeBefore = Date()
			
			getPrediction(stationCode: stationCode, onCompleted: {
				trainResponse in
				if trainResponse.errorCode == nil {
					var trainsLevelOne = trainResponse.trains!
					
					self.handleTwoLevelStation(stationCode: stationCode, onCompleted: {
						trainResponse in
						if trainResponse.errorCode == nil {
							if trainResponse.trains != nil {
								let trainsLevelTwo = trainResponse.trains!
								if self.isSpaceInTrainArray {
									trainsLevelOne.append(Train.initSpace())
								}
								onCompleted(TrainResponse(trains: trainsLevelOne + trainsLevelTwo, errorCode: nil))
							} else {
								onCompleted(TrainResponse(trains: trainsLevelOne, errorCode: nil))
							}
						} else {
							onCompleted(trainResponse)
						}
					})
					
				} else {
					onCompleted(trainResponse)
				}
			})
		}
	}
	
	/// Checks the station code to see if it is one of the four metro stations that have two levels.  If it is, fetch the predictions for the station code and return it in a Train array.
	///
	/// WMATA API documentation: "Some stations have two platforms (e.g.: Gallery Place, Fort Totten, L'Enfant Plaza, and Metro Center). To retrieve complete predictions for these stations, be sure to pass in both StationCodes."
	///
	/// - Parameters:
	///   - stationCode: the three digit station code
	///   - onCompleted: the completion handler
	///   - result: the TrainResponse
	fileprivate func handleTwoLevelStation(stationCode: String, onCompleted: @escaping (_ result: TrainResponse) -> ()) {
		/// Mutable copy of stationCode
		var stationCode = stationCode
		/// The four WMATA stations that have two levels:
		///							Metro Center;		Gallery Place;	Fort Totten;    and L'Enfant Plaza.
		let twoLevelStations = [	Station.A01,		Station.B01,	Station.B06,		Station.D03]
		
		if twoLevelStations.contains(Station(rawValue: stationCode)!) {
			switch stationCode {
			case "A01": stationCode = "C01"
			case "B01": stationCode = "F01"
			case "B06": stationCode = "E06"
			case "D03": stationCode = "F03"
			default: break
			}
			
			getPrediction(stationCode: stationCode, onCompleted: {
				trainResponse in
				onCompleted(trainResponse)
			})
		} else {
			onCompleted(TrainResponse(trains: nil, errorCode: nil))
		}
	}
	
	/// Queries WMATA's API to fetch the stationCode's next train arrivals
	///
	/// - Parameters:
	///   - stationCode: the three digit station code
	///   - onCompleted: the completion handler
	///   - result: the TrainResponse
	fileprivate func getPrediction(stationCode: String, onCompleted: @escaping (_ result: TrainResponse) -> ()) {
		print("WMATAFetcher: fetching predictions for \((Station(rawValue: stationCode)?.rawValue)!) (\((Station(rawValue: stationCode)?.description)!))")
		
		guard let wmataURL = URL(string: WMATA_PREDICTION_BASE_URL + stationCode) else {
			return
		}
		
		var request = URLRequest(url: wmataURL)
		
		request.addValue(WMATA_API_KEY, forHTTPHeaderField: "api_key")
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if error == nil {
				let statusCode = (response as! HTTPURLResponse).statusCode
				if statusCode == 200 { // success
					let trains = self.populateTrainArray(json: JSON(data: data!))
					onCompleted(TrainResponse(trains: trains, errorCode: nil))
				} else {
					onCompleted(TrainResponse(trains: nil, errorCode: statusCode))
				}
			} else {
				onCompleted(TrainResponse(trains: nil, errorCode: (error as! NSError).code))
			}
			}.resume()
	}
	
	/// Parses the JSON object to create an array of Trains
	///
	/// - Parameter json: the JSON to be parsed
	/// - Returns: an array of Trains
	fileprivate func populateTrainArray(json: JSON) -> [Train] {
		// the JSON will always contain one root element, "Trains."
		// Setting json to its children
		let json = json["Trains"]
		var trains = [Train]()
		
		for (_, subJson): (String, JSON) in json {
			var line: Line? = nil
			var min: String? = nil
			var numCars: String? = nil
			var destination: Station? = nil
			
			if subJson["DestinationName"].stringValue == Station.No.description || subJson["DestinationName"].stringValue == Station.Train.description {
				line = Line.NO
				min = subJson["Min"] == JSON.null ? "-" : subJson["Min"].stringValue
				numCars = "-"
				destination = subJson["DestinationName"].stringValue == Station.No.description ? Station.No : Station.Train
			}
			
			if subJson["Min"].stringValue == "" {
				continue
			}
			
			trains.append(Train(numCars: numCars ?? subJson["Car"].stringValue,
			                    destination: destination ?? Station(rawValue: subJson["DestinationCode"].stringValue)!,
			                    group: subJson["Group"].stringValue,
			                    line: line ?? Line(rawValue: subJson["Line"].stringValue)!,
			                    location: Station(rawValue: subJson["LocationCode"].stringValue)!,
			                    min: min ?? subJson["Min"].stringValue))
		}
		
		trains.sort(by: { $0.group < $1.group })
		
		// Insert a space between each group
		for (index, train) in trains.enumerated() {
			if trains.get(index: index + 1) != nil && train.group != trains[index + 1].group && self.isSpaceInTrainArray {
				trains.insert(Train.initSpace(), at: index + 1)
			}
		}
		
		return trains
	}
	
	/// Returns the closest metro stations to location.  If numStations is below 1, this method
	/// will return 5 stations.
	///
	/// - Parameters:
	///   - location: the location
	///   - numStations: the number of stations to include in the Station array
	/// - Returns: a Station array containing numStations closest stations to location
	open func getClosestStations(location: CLLocation, numStations: Int) -> [Station] {
		/// Mutable copy of numStations
		var numStations = numStations
		if numStations < 1 {
			numStations = 5
		}
		
		var closestStations = [Station]()
		var distancesDictionary: [CLLocationDistance:String] = [:]
		
		for station in Station.allValues {
			distancesDictionary[station.location.distance(from: location)] = station.rawValue
		}
		
		let sortedDistancesKeys = Array(distancesDictionary.keys).sorted(by: <)
		
		for (index, key) in sortedDistancesKeys.enumerated() {
			closestStations.append(Station(rawValue: distancesDictionary[key]!)!)
			if index == numStations - 1 {
				break;
			}
		}
		
		return closestStations
	}
	
	/// Determines the distance from the specified location to the specified station.
	///
	/// - Parameters:
	///   - location: the location
	///   - station: the Station
	///   - isMetric: if true, metric units are used. if false, imperial units are used.
	/// - Returns: a String describing the distance, with 1 decimal precision if km or mi.
	open func getDistanceFromStation(location: CLLocation, station: Station, isMetric: Bool) -> String {
		var distanceToStation = station.location.distance(from: location)
		var units: String
		var decimal: String
		
		// 1 meter == 3.280839895 feet
		distanceToStation = isMetric ? distanceToStation : distanceToStation / 3.280839895
		
		if (distanceToStation < 1000 && isMetric) || (distanceToStation < 528 && !isMetric) {
			decimal = "0"
			units = isMetric ? "m" : "ft"
		} else {
			decimal = "1"
			units = isMetric ? "km" : "mi"
			distanceToStation = isMetric ? distanceToStation / 1000 : distanceToStation / 5280
		}
		
		return String(format:"%." + decimal + "f " + units, distanceToStation)
	}
	
	/// Determines the number of spaces in the Train array
	///
	/// - Parameter trains: the Train array
	/// - Returns: the number of spaces in the Train array
	open func getSpaceCount(trains: [Train]) -> Int {
		var spaceCount = 0;
		for train in trains {
			if train.location == Station.Space {
				spaceCount += 1
			}
		}
		
		return spaceCount
	}
}

extension Array {
	/// Safely lookup an index that might be out of bounds
	///
	/// Adapted from http://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
	///
	/// - Parameter index: the index of the element to return
	/// - Returns: the element if it exists, otherwise nil
	func get(index: Int) -> Element? {
		if 0 <= index && index < count {
			return self[index]
		} else {
			return nil
		}
	}
}
