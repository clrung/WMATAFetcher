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

/**
Based on WMATA's definition of IMPredictionTrainInfo, found here: https://developer.wmata.com/docs/services/547636a6f9182302184cda78/operations/547636a6f918230da855363f/console#AIMPredictionTrainInfo
*/
public class Train {
	
	public var numCars: String = ""
	public var destination: Station = Station.A01
		// abbreviated destination is not used.
		// destinationCode:	destination.rawValue
		// destinationName:	destination.description
	public var group: String = ""
	public var line: Line = Line.NO
	public var location: Station = Station.A01
		// locationCode:	location.rawValue
		// locationName:	location.description
	public var min: String = "0"
	
	required public init(numCars: String, destination: Station, group: String, line: Line, location: Station, min: String) {
		self.numCars = numCars
		self.destination = destination
		self.group = group
		self.line = line
		self.location = location
		self.min = min
	}
	
	static func initSpace() -> Train {
		return Train(numCars: "", destination: Station.Space, group: "-1", line: Line.NO, location: Station.Space, min: "")
	}
	
	var debugDescription: String {
		return "numCars: \(numCars)   " +
		"destination: \(destination.description)   " +
		"group: \(group)   " +
		"line: \(line.rawValue)   " +
		"location: \(location.description)   " +
		"min: \(min)"
	}
	
}