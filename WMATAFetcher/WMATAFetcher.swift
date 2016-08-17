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
	
	private var WMATA_API_KEY = ""
	
	public var trains: [Train] = []
	public var spaceCount = 0
	public var selectedStation: Station = Station(rawValue: NSUserDefaults.standardUserDefaults().stringForKey("selectedStation") ?? "No")!
	
	var predictionJSON: JSON = JSON.null
	//						Metro Center	Gallery Pl		Fort Totten		L'Enfant Plaza
	let twoLevelStations = [Station.A01,	Station.B01,	Station.B06,	Station.D03,
	                        Station.C01,	Station.F01,	Station.E06,	Station.F03]
	var timeBefore: NSDate = NSDate(timeIntervalSinceNow: NSTimeInterval(-2))
	
	public init(WMATA_API_KEY:String) {
		self.WMATA_API_KEY = WMATA_API_KEY
	}
	
	/**
	Wrapper method that calls getPrediction(), passing it the selectedStation.
	*/
	public func getPredictionsForSelectedStation() {
		getPrediction(selectedStation.rawValue, onCompleted: {
			result in
			self.predictionJSON = result!
			self.spaceCount = 0
			self.populateTrainArray()
			self.handleTwoLevelStation()
			if self.trains.count == 0 {
				NSNotificationCenter.defaultCenter().postNotificationName("error", object: nil, userInfo: ["errorString":"No trains are currently arriving"])
			} else {
				NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil)
			}
		})
	}
	
	/**
	Queries WMATA's API to fetch the stationCode's next train arrivals
	
	- parameter stationCode: the two digit station code
	- returns: A JSON containing prediction data, or nil if there was an error
	*/
	public func getPrediction(stationCode: String, onCompleted: (result: JSON?) -> ()) {
		let timeAfter = NSDate()
		
		let secondHalfTwoLevelStations: [Station] = Array(twoLevelStations.split(Station.D03).last!)
		var secondHalfTwoLevelStationCodes: [String] = []
		for station in secondHalfTwoLevelStations {
			secondHalfTwoLevelStationCodes.append(station.rawValue)
		}
		
		// only fetch new predictions if it has been at least one second since they were last fetched or it is the second part of a two level station fetch
		if timeAfter.timeIntervalSinceDate(timeBefore) > 1 || secondHalfTwoLevelStationCodes.contains(stationCode) {
			print("WMATAFetcher: fetching predictions for \((Station(rawValue: stationCode)?.rawValue)!) (\((Station(rawValue: stationCode)?.description)!))")
			
			timeBefore = NSDate()
			
			guard let wmataURL = NSURL(string: "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/" + stationCode) else {
				return
			}
			
			let request = NSMutableURLRequest(URL: wmataURL)
			let session = NSURLSession.sharedSession()
			
			request.setValue(WMATA_API_KEY, forHTTPHeaderField:"api_key")
			
			session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
				if error == nil {
					let statusCode = (response as! NSHTTPURLResponse).statusCode
					if statusCode == 200 { // success
						onCompleted(result: JSON(data: data!))
					} else { // error
						NSNotificationCenter.defaultCenter().postNotificationName("error", object: nil, userInfo: ["errorString":"Prediction fetch failed (Code: \(statusCode))"])
					}
				} else {
					if error?.code == -1009 {
						NSNotificationCenter.defaultCenter().postNotificationName("error", object: nil, userInfo: ["errorString":"Internet connection is offline"])
					}
				}
			}).resume()
		}
	}
	
	/**
	Populates the train array by parsing the predictionJSON object
	*/
	public func populateTrainArray() {
		trains = []
		
		// the JSON contains one root element, "Trains"
		predictionJSON = predictionJSON["Trains"]
		
		for (_, subJson): (String, JSON) in predictionJSON {
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
		
		for (index, train) in trains.enumerate() {
			if trains.get(index + 1) != nil && train.group != trains[index + 1].group {
				trains.insert(Train.initSpace(), atIndex: index + 1)
				spaceCount += 1
			}
		}
	}
	
	/**
	Checks the selected station to see if it is one of the four metro stations that have two levels.  If it is, fetch the predictions for the second station code, add it to the trains array, and reload the table view.
	
	WMATA API: "Some stations have two platforms (e.g.: Gallery Place, Fort Totten, L'Enfant Plaza, and Metro Center). To retrieve complete predictions for these stations, be sure to pass in both StationCodes."
	*/
	public func handleTwoLevelStation() {
		let stationBefore = selectedStation
		if twoLevelStations.contains(selectedStation) {
			switch selectedStation {
			case Station.A01: selectedStation = Station.C01
			case Station.B01: selectedStation = Station.F01
			case Station.B06: selectedStation = Station.E06
			case Station.D03: selectedStation = Station.F03
			default: break
			}
			
			getPrediction(selectedStation.rawValue, onCompleted: {
				result in
				self.predictionJSON = result!
				
				let trainsGroup1 = self.trains
				self.populateTrainArray()
				self.trains.append(Train.initSpace())
				self.spaceCount += 1
				self.trains = self.trains + trainsGroup1
				
				NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil)
			})
		}
		selectedStation = stationBefore
	}
	
	/**
	Gets the five closest metro stations to location.
	
	- parameter location: The location
	- returns: A Station array containing the five closest stations to location.
	*/
	public func getfiveClosestStations(location: CLLocation) -> [Station] {
		var fiveClosestStations = [Station]()
		var distancesDictionary: [CLLocationDistance:String] = [:]
		
		for station in Station.allValues {
			distancesDictionary[station.location.distanceFromLocation(location)] = station.rawValue
		}
		
		let sortedDistancesKeys = Array(distancesDictionary.keys).sort(<)
		
		for (index, key) in sortedDistancesKeys.enumerate() {
			fiveClosestStations.append(Station(rawValue: distancesDictionary[key]!)!)
			if index == 4 {
				break;
			}
		}
		
		return fiveClosestStations
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