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

public class WMATAFetcher {

	/**
	The start of the WMATA API call
	*/
	private var WMATA_PREDICTION_BASE_URL = "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/"
	/**
	The developer's WMATA API key
	*/
	private var WMATA_API_KEY: String
	
	/**
	If true, the train array will include spaces between each group.
	*/
	private var trainArrayShouldIncludeSpaces: Bool
	
	/**
	The time the WMATAFetcher is instantiated
	*/
	private var timeBefore: NSDate = NSDate(timeIntervalSinceNow: NSTimeInterval(-2))
	
	/**
	Default constructor.  Creates a WMATAFetcher, provided a WMATA API key is supplied, and includes spaces between groups.
	
	- parameter WMATA_API_KEY: The developer's WMATA API key.  Get a free key after you [create an account](https://developer.wmata.com/signup/).
	- returns: The created WMATAFetcher
	*/
	public required init(WMATA_API_KEY: String) {
		self.WMATA_API_KEY = WMATA_API_KEY
		self.trainArrayShouldIncludeSpaces = true
	}
	
	/**
	Creates a WMATAFetcher, provided a WMATA API key is supplied.
	
	- parameter WMATA_API_KEY: The developer's WMATA API key.  Get a free key after you [create an account](https://developer.wmata.com/signup/).
	- parameter trainArrayShouldIncludeSpaces: if true, spaces will separate each group in the trains array.
	- returns: The created WMATAFetcher
	*/
	public required init(WMATA_API_KEY: String, trainArrayShouldIncludeSpaces: Bool) {
		self.WMATA_API_KEY = WMATA_API_KEY
		self.trainArrayShouldIncludeSpaces = trainArrayShouldIncludeSpaces
	}
	
	/**
	Queries WMATA's API to fetch the stationCode's next train arrivals
	
	- parameter stationCode: the two digit station code
	- parameter onCompleted: handles what to do after this code executes
	- returns: A TrainResponse, which contains an array of Trains and an error message.
	*/
	public func getPrediction(stationCode: String, onCompleted: (result: TrainResponse) -> ()) {
		let timeAfter = NSDate()
		
		// only fetch new predictions if it has been at least one second since they were last fetched
		if timeAfter.timeIntervalSinceDate(timeBefore) > 1 {
			timeBefore = NSDate()
			
			guard let wmataURL = NSURL(string: WMATA_PREDICTION_BASE_URL + stationCode) else {
				return
			}
			
			let request = NSMutableURLRequest(URL: wmataURL)
			
			request.setValue(WMATA_API_KEY, forHTTPHeaderField:"api_key")
			
			print("WMATAFetcher: fetching predictions for \((Station(rawValue: stationCode)?.rawValue)!) (\((Station(rawValue: stationCode)?.description)!))")
			NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
				if error == nil {
					let statusCode = (response as! NSHTTPURLResponse).statusCode
					if statusCode == 200 { // success
						let firstLevelTrains = self.populateTrainArray(JSON(data: data!))
						self.handleTwoLevelStation(stationCode, onCompleted: {
							secondLevelTrains in
							let trains = firstLevelTrains + secondLevelTrains
							onCompleted(result: TrainResponse(trains: trains, error: nil))
						})
					} else {
						onCompleted(result: TrainResponse(trains: nil, error: "Prediction fetch failed (Code: \(statusCode))"))
					}
				} else {
					if error?.code == -1009 {
						onCompleted(result: TrainResponse(trains: nil, error: "Internet connection is offline"))
					}
				}
			}).resume()
		}
	}
	
	/**
	Parses the json to create an array of Trains
	
	- parameter json: the JSON to be parsed
	- return an array of Trains
	*/
	private func populateTrainArray(json: JSON) -> [Train] {
		// the JSON will always contain one root element, "Trains."
		// Stripping this out to get to the elements.
		let json = json["Trains"]
		var trains = [Train]()
		
		for (_, subJson): (String, JSON) in json {
			var line: Line? = nil
			var min: String? = nil
			var numCars: String? = nil
			var destination: Station? = nil
			
			if subJson["DestinationName"].stringValue == Station.No.description || subJson["DestinationName"].stringValue == Station.Train.description {
				line = Line.NO
				min = subJson["Min"] == nil ? "-" : subJson["Min"].stringValue
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
		
		trains.sortInPlace({ $0.group < $1.group })
		
		// Insert a space between each group
		for (index, train) in trains.enumerate() {
			if trains.get(index + 1) != nil && train.group != trains[index + 1].group && self.trainArrayShouldIncludeSpaces {
				trains.insert(Train.initSpace(), atIndex: index + 1)
			}
		}
		
		return trains
	}
	
	/**
	Checks the station code to see if it is one of the four metro stations that have two levels.  If it is, fetch the predictions for the station code and return it in a Train array.
	
	WMATA API: "Some stations have two platforms (e.g.: Gallery Place, Fort Totten, L'Enfant Plaza, and Metro Center). To retrieve complete predictions for these stations, be sure to pass in both StationCodes."
	
	- parameter stationCode: the station code to fetch
	- returns: an array of Trains which store the second level trains' predictions, or an empty array if the station does not have a second level or there was a failure
	*/
	private func handleTwoLevelStation(stationCode: String, onCompleted: (result: [Train]) -> ()) {
		/**
		Mutable copy of stationCode
		*/
		var stationCode = stationCode
		/**
		The four WMATA stations that have two levels:
									Metro Center;		Gallery Place;	Fort Totten;    and L'Enfant Plaza.
		*/
		let twoLevelStations = [	Station.A01,		Station.B01,	Station.B06,		Station.D03]
		
		if twoLevelStations.contains(Station(rawValue: stationCode)!) {
			switch stationCode {
			case "A01": stationCode = "C01"
			case "B01": stationCode = "F01"
			case "B06": stationCode = "E06"
			case "D03": stationCode = "F03"
			default: break
			}
			
			guard let wmataURL = NSURL(string: WMATA_PREDICTION_BASE_URL + stationCode) else {
				return
			}
			
			let request = NSMutableURLRequest(URL: wmataURL)
			
			request.setValue(WMATA_API_KEY, forHTTPHeaderField:"api_key")
			
			print("WMATAFetcher: fetching predictions for \((Station(rawValue: stationCode)?.rawValue)!) (\((Station(rawValue: stationCode)?.description)!))")
			NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
				if error == nil {
					let statusCode = (response as! NSHTTPURLResponse).statusCode
					if statusCode == 200 { // success
						var secondLevelTrains = self.populateTrainArray(JSON(data: data!))
						if self.trainArrayShouldIncludeSpaces {
							secondLevelTrains.insert(Train.initSpace(), atIndex: 0)
						}
						onCompleted(result: secondLevelTrains)
					} else {
						onCompleted(result: [])
					}
				} else {
					onCompleted(result: [])
				}
			}).resume()
			onCompleted(result: [])
		} else {
			onCompleted(result: [])
		}
	}
	
	/**
	Returns the closest metro stations to location.  If numStations is invalid, this method
	will return 5 stations.
	
	- parameter location: The location
	- parameter numStations: The number of stations to include in the Station array
	- returns: A Station array containing numStations closest stations to location
	*/
	public func getClosestStations(location: CLLocation, numStations: Int) -> [Station] {
		/**
		Mutable copy of the numStations
		*/
		var numStations = numStations
		if numStations < 1 {
			numStations = 5
		}
		
		var closestStations = [Station]()
		var distancesDictionary: [CLLocationDistance:String] = [:]
		
		for station in Station.allValues {
			distancesDictionary[station.location.distanceFromLocation(location)] = station.rawValue
		}
		
		let sortedDistancesKeys = Array(distancesDictionary.keys).sort(<)
		
		for (index, key) in sortedDistancesKeys.enumerate() {
			closestStations.append(Station(rawValue: distancesDictionary[key]!)!)
			if index == numStations - 1 {
				break;
			}
		}
		
		return closestStations
	}
	
	/**
	Determines the number of spaces in the Train array
	
	- parameter trains: the Train array
	- returns: the number of spaces in the Train array
	*/
	public func getSpaceCount(trains: [Train]) -> Int {
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
	/**
	Safely lookup an index that might be out of bounds
	
	Adapted from http://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
	
	- parameter index: the index of the element to return
	- returns: the element if it exists, otherwise nil
	*/
	func get(index: Int) -> Element? {
		if 0 <= index && index < count {
			return self[index]
		} else {
			return nil
		}
	}
}