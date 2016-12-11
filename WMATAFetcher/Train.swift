//
//  Train.swift
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

/// Based on WMATA's definition of [IMPredictionTrainInfo](https://developer.wmata.com/docs/services/547636a6f9182302184cda78/operations/547636a6f918230da855363f/console#AIMPredictionTrainInfo).
open class Train {
	/// The number of cars in the train
	open var numCars: String = ""
	/// The destination.  Abbreviated destination is not used, and the destinationCode and destinationName can be determined by calling destination.rawValue and destination.description, respectively.
	open var destination: Station = Station.A01
	/// The group
	open var group: String = ""
	/// The line color
	open var line: Line = Line.NO
	/// The current location of the train.  The locationCode and locationName can be determined by calling location.rawValue and location.description, respectively.
	open var location: Station = Station.A01
	/// The number of minutes until the train arrives at the station.
	open var min: String = "0"
	/// Constructor
	///
	/// - Parameters:
	///   - numCars: the number of cars
	///   - destination: the destination Station
	///   - group: the group
	///   - line: the Line
	///   - location: the location Station of the Train
	///   - min: the estimated number of minutes until the Train arrives at the location
	required public init(numCars: String, destination: Station, group: String, line: Line, location: Station, min: String) {
		self.numCars = numCars
		self.destination = destination
		self.group = group
		self.line = line
		self.location = location
		self.min = min
	}
	
	/// Used to easily add a Station.Space object to the train array.
	static func initSpace() -> Train {
		return Train(numCars: "", destination: Station.Space, group: "-1", line: Line.NO, location: Station.Space, min: "")
	}
	
	/// Returns the value of each of the fields in Train.
	open var debugDescription: String {
		return "numCars: \(numCars)\t" +
		"destination: \(destination.description)\t" +
		"group: \(group)\t" +
		"line: \(line.rawValue)\t" +
		"location: \(location.description)\t" +
		"min: \(min)"
	}
	
}

/// Stores the Train array and an error code.
public struct TrainResponse {
	/// The array of Trains.  `nil` when the call to `getPrediction()` is unsuccessful.
	public var trains: [Train]?
	/// The HTTP status code.  `nil` when `getPrediction()` is successful.  Common error codes:
	///
	/// 1. -1009: The internet connection is offline
	/// 2. 403: Invalid request (likely a bad WMATA key)
	public var errorCode: Int?
	
	/// TrainResponse constructor
	///
	/// - Parameters:
	///   - trains: the Train array
	///   - errorCode: the errorCode
	public init(trains: [Train]?, errorCode: Int?) {
		self.trains = trains
		self.errorCode = errorCode
	}
}
