//
//  Station.swift
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
import CoreLocation

/**
Represents each of the stations in the WMATA system
*/
public enum Station: String, CustomStringConvertible {
	/// Metro Center
	case A01
	/// Farragut North
	case A02
	/// Dupont Circle
	case A03
	/// Woodley Park-Zoo/Adams Morgan
	case A04
	/// Cleveland Park
	case A05
	/// Van Ness-UDC
	case A06
	/// Tenleytown-AU
	case A07
	/// Friendship Heights
	case A08
	/// Bethesda
	case A09
	/// Medical Center
	case A10
	/// Grosvenor-Strathmore
	case A11
	/// White Flint
	case A12
	/// Twinbrook
	case A13
	/// Rockville
	case A14
	/// Shady Grove
	case A15
	/// Gallery Pl-Chinatown
	case B01
	/// Judiciary Square
	case B02
	/// Union Station
	case B03
	/// Rhode Island Ave-Brentwood
	case B04
	/// Brookland-CUA
	case B05
	/// Fort Totten
	case B06
	/// Takoma
	case B07
	/// Silver Spring
	case B08
	/// Forest Glen
	case B09
	/// Wheaton
	case B10
	/// Glenmont
	case B11
	/// NoMA-Gallaudet U
	case B35
	/// Metro Center
	case C01
	/// McPherson Square
	case C02
	/// Farragut West
	case C03
	/// Foggy Bottom-GWU
	case C04
	/// Rosslyn
	case C05
	/// Arlington Cemetary
	case C06
	/// Pentagon
	case C07
	/// Pentagon City
	case C08
	/// Crystal City
	case C09
	/// Reagan National Airport
	case C10
	/// Braddock Road
	case C12
	/// King St-Old Town
	case C13
	/// Eisenhower Avenue
	case C14
	/// Huntington
	case C15
	/// Federal Triangle
	case D01
	/// Smithsonian
	case D02
	/// L'Enfant Plaza
	case D03
	/// Federal Center SW
	case D04
	/// Capitol South
	case D05
	/// Eastern Market
	case D06
	/// Potomac Ave
	case D07
	/// Stadium-Armory
	case D08
	/// Minnesota Ave
	case D09
	/// Deanwood
	case D10
	/// Cheverly
	case D11
	/// Landover
	case D12
	/// New Carrollton
	case D13
	/// Mt Vernon Sq
	case E01
	/// Shaw-Howard U
	case E02
	/// U Street
	case E03
	/// Columbia Heights
	case E04
	/// Georgia Ave-Petworth
	case E05
	/// Fort Totten
	case E06
	/// West Hyattsville
	case E07
	/// Prince George's Plaza
	case E08
	/// College Park-U of MD
	case E09
	/// Greenbelt
	case E10
	/// Gallery Pl-Chinatown
	case F01
	/// Archives
	case F02
	/// L'Enfant Plaza
	case F03
	/// Waterfront
	case F04
	/// Navy Yard-Ballpark
	case F05
	/// Anacostia
	case F06
	/// Congress Heights
	case F07
	/// Southern Avenue
	case F08
	/// Naylor Road
	case F09
	/// Suitland
	case F10
	/// Branch Ave
	case F11
	/// Benning Road
	case G01
	/// Capitol Heights
	case G02
	/// Addison Road-Seat Pleasant
	case G03
	/// Morgan Boulevard
	case G04
	/// Largo Town Center
	case G05
	/// Van Dorn Street
	case J02
	/// Franconia-Springfield
	case J03
	/// Court House
	case K01
	/// Clarendon
	case K02
	/// Virginia Square-GMU
	case K03
	/// Ballston-MU
	case K04
	/// East Falls Church
	case K05
	/// West Falls Church-UT/UVA
	case K06
	/// Dunn Loring-Merrifield
	case K07
	/// Vienna/Fairfax/GMU
	case K08
	/// McLean
	case N01
	/// Tyson's Corner
	case N02
	/// Greensboro
	case N03
	/// Spring Hill
	case N04
	/// Wiehle-Reston East
	case N06
	/// Train
	case Train
	/// No Passenger
	case No
	/// Space
	case Space
	
	/**
	Facilitates enumeration of all Metro stations (Source: http://www.swift-studies.com/blog/2014/6/10/enumerating-enums-in-swift)
	*/
	public static let allValues = [A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11, A12, A13, A14, A15,
	                        B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11, B35,
	                        C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C12, C13, C14, C15,
	                        D01, D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13,
	                        E01, E02, E03, E04, E05, E06, E07, E08, E09, E10,
	                        F01, F02, F03, F04, F05, F06, F07, F08, F09, F10, F11,
	                        G01, G02, G03, G04, G05,
	                        J02, J03,
	                        K01, K02, K03, K04, K05, K06, K07, K08,
	                        N01, N02, N03, N04, N06]
	
	/**
	Returns the Station that corresponds to the given description, or nil if the description was invalid
	
	- parameter description: The name of the Metro station (case-insensitive)
	*/
	public init?(description: String) {
		switch description.lowercaseString {
		case "metro center":					self = .A01
		case "farragut north":					self = .A02
		case "dupont circle":					self = .A03
		case "woodley park-zoo/adams morgan":	self = .A04
		case "cleveland park":					self = .A05
		case "van ness-udc":					self = .A06
		case "tenleytown-au":					self = .A07
		case "friendship heights":				self = .A08
		case "bethesda":						self = .A09
		case "medical center":					self = .A10
		case "grosvenor-strathmore":			self = .A11
		case "white flint":						self = .A12
		case "twinbrook":						self = .A13
		case "rockville":						self = .A14
		case "shady grove":						self = .A15
		case "gallery pl-chinatown":			self = .B01
		case "judiciary square":				self = .B02
		case "union station":					self = .B03
		case "rhode island ave-brentwood":		self = .B04
		case "brookland-cua":					self = .B05
		case "fort totten":						self = .B06
		case "takoma":							self = .B07
		case "silver spring":					self = .B08
		case "forest glen":						self = .B09
		case "wheaton":							self = .B10
		case "glenmont":						self = .B11
		case "noma-gallaudet u":				self = .B35
		case "mcpherson square":				self = .C02
//		case "metro center": ignoring; set to A01 earlier
		case "farragut west":					self = .C03
		case "foggy bottom-gwu":				self = .C04
		case "rosslyn":							self = .C05
		case "arlington cemetary":				self = .C06
		case "pentagon":						self = .C07
		case "pentagon city":					self = .C08
		case "crystal city":					self = .C09
		case "reagan national airport":			self = .C10
		case "braddock road":					self = .C12
		case "king st-old town":				self = .C13
		case "eisenhower avenue":				self = .C14
		case "huntington":						self = .C15
		case "federal triangle":				self = .D01
		case "smithsonian":						self = .D02
		case "l'enfant plaza":					self = .D03
		case "federal center sw":				self = .D04
		case "capitol south":					self = .D05
		case "eastern market":					self = .D06
		case "potomac ave":						self = .D07
		case "stadium-armory":					self = .D08
		case "minnesota ave":					self = .D09
		case "deanwood":						self = .D10
		case "cheverly":						self = .D11
		case "landover":						self = .D12
		case "new carrollton":					self = .D13
		case "mt vernon sq":					self = .E01
		case "shaw-howard u":					self = .E02
		case "u street":						self = .E03
		case "columbia heights":				self = .E04
		case "georgia ave-petworth":			self = .E05
//		case "fort totten": ignoring; set to B06 earlier
		case "west hyattsville":				self = .E07
		case "prince george's plaza":			self = .E08
		case "college park-u of md":			self = .E09
		case "greenbelt":						self = .E10
//		case "gallery pl-chinatown": ignoring; set to B01 earlier
		case "archives":						self = .F02
//		case "l'enfant plaza": ignoring; set to D03 earlier
		case "waterfront":						self = .F04
		case "navy yard-ballpark":				self = .F05
		case "anacostia":						self = .F06
		case "congress heights":				self = .F07
		case "southern avenue":					self = .F08
		case "naylor road":						self = .F09
		case "suitland":						self = .F10
		case "branch ave":						self = .F11
		case "benning road":					self = .G01
		case "capitol heights":					self = .G02
		case "addison road-seat pleasant":		self = .G03
		case "morgan boulevard":				self = .G04
		case "largo town center":				self = .G05
		case "van dorn street":					self = .J02
		case "franconia-springfield":			self = .J03
		case "court house":						self = .K01
		case "clarendon":						self = .K02
		case "virginia square-gmu":				self = .K03
		case "ballston-mu":						self = .K04
		case "east falls church":				self = .K05
		case "west falls church-ut/uva":		self = .K06
		case "dunn loring-merrifield":			self = .K07
		case "vienna/fairfax/gmu":				self = .K08
		case "mclean":							self = .N01
		case "tyson's corner":					self = .N02
		case "greensboro":						self = .N03
		case "spring hill":						self = .N04
		case "wiehle-reston east":				self = .N06
		default:
			print("Station: invalid description")
			return nil
		}
	}
	
	/**
	The name of the Metro station
	*/
	public var description : String {
		switch self {
		case A01: return "Metro Center"
		case A02: return "Farragut North"
		case A03: return "Dupont Circle"
		case A04: return "Woodley Park-Zoo/Adams Morgan"
		case A05: return "Cleveland Park"
		case A06: return "Van Ness-UDC"
		case A07: return "Tenleytown-AU"
		case A08: return "Friendship Heights"
		case A09: return "Bethesda"
		case A10: return "Medical Center"
		case A11: return "Grosvenor-Strathmore"
		case A12: return "White Flint"
		case A13: return "Twinbrook"
		case A14: return "Rockville"
		case A15: return "Shady Grove"
		case B01: return "Gallery Pl-Chinatown"
		case B02: return "Judiciary Square"
		case B03: return "Union Station"
		case B04: return "Rhode Island Ave-Brentwood"
		case B05: return "Brookland-CUA"
		case B06: return "Fort Totten"
		case B07: return "Takoma"
		case B08: return "Silver Spring"
		case B09: return "Forest Glen"
		case B10: return "Wheaton"
		case B11: return "Glenmont"
		case B35: return "NoMa-Gallaudet U"
		case C01: return "Metro Center"
		case C02: return "McPherson Square"
		case C03: return "Farragut West"
		case C04: return "Foggy Bottom-GWU"
		case C05: return "Rosslyn"
		case C06: return "Arlington Cemetary"
		case C07: return "Pentagon"
		case C08: return "Pentagon City"
		case C09: return "Crystal City"
		case C10: return "Reagan National Airport"	// shortened from "Ronald Reagan Washington National Airport"
		case C12: return "Braddock Road"
		case C13: return "King St-Old Town"
		case C14: return "Eisenhower Avenue"
		case C15: return "Huntington"
		case D01: return "Federal Triangle"
		case D02: return "Smithsonian"
		case D03: return "L'Enfant Plaza"
		case D04: return "Federal Center SW"
		case D05: return "Capitol South"
		case D06: return "Eastern Market"
		case D07: return "Potomac Ave"
		case D08: return "Stadium-Armory"
		case D09: return "Minnesota Ave"
		case D10: return "Deanwood"
		case D11: return "Cheverly"
		case D12: return "Landover"
		case D13: return "New Carrollton"
		case E01: return "Mt Vernon Sq"				// shortened from "Mt Vernon Sq 7th St-Convention Center"
		case E02: return "Shaw-Howard U"
		case E03: return "U Street"					// shortened from "U Street/African-Amer Civil War Memorial/Cardozo"
		case E04: return "Columbia Heights"
		case E05: return "Georgia Ave-Petworth"
		case E06: return "Fort Totten"
		case E07: return "West Hyattsville"
		case E08: return "Prince George's Plaza"
		case E09: return "College Park-U of MD"
		case E10: return "Greenbelt"
		case F01: return "Gallery Pl-Chinatown"
		case F02: return "Archives"					// shortened from "Archives-Navy Memorial-Penn Quarter"
		case F03: return "L'Enfant Plaza"
		case F04: return "Waterfront"
		case F05: return "Navy Yard-Ballpark"
		case F06: return "Anacostia"
		case F07: return "Congress Heights"
		case F08: return "Southern Avenue"
		case F09: return "Naylor Road"
		case F10: return "Suitland"
		case F11: return "Branch Ave"
		case G01: return "Benning Road"
		case G02: return "Capitol Heights"
		case G03: return "Addison Road-Seat Pleasant"
		case G04: return "Morgan Boulevard"
		case G05: return "Largo Town Center"
		case J02: return "Van Dorn Street"
		case J03: return "Franconia-Springfield"
		case K01: return "Court House"
		case K02: return "Clarendon"
		case K03: return "Virginia Square-GMU"
		case K04: return "Ballston-MU"
		case K05: return "East Falls Church"
		case K06: return "West Falls Church-UT/UVA"
		case K07: return "Dunn Loring-Merrifield"
		case K08: return "Vienna/Fairfax/GMU"
		case N01: return "McLean"
		case N02: return "Tyson's Corner"
		case N03: return "Greensboro"
		case N04: return "Spring Hill"
		case N06: return "Wiehle-Reston East"
		case Train: return "Train"
		case No: return "No Passenger"
		case Space: return ""
		}
	}
	
	/**
	The location of each Metro station
	*/
	public var location: CLLocation {
		switch self {
		case A01: return CLLocation(latitude: 38.898303, longitude: -77.028099)
		case A02: return CLLocation(latitude: 38.903192, longitude: -77.039766)
		case A03: return CLLocation(latitude: 38.909499, longitude: -77.04362)
		case A04: return CLLocation(latitude: 38.924999, longitude: -77.052648)
		case A05: return CLLocation(latitude: 38.934703, longitude: -77.058226)
		case A06: return CLLocation(latitude: 38.94362, longitude: -77.0635110)
		case A07: return CLLocation(latitude: 38.947808, longitude: -77.079615)
		case A08: return CLLocation(latitude: 38.960744, longitude: -77.085969)
		case A09: return CLLocation(latitude: 38.984282, longitude: -77.094431)
		case A10: return CLLocation(latitude: 38.999947, longitude: -77.0972529)
		case A11: return CLLocation(latitude: 39.029158, longitude: -77.10415)
		case A12: return CLLocation(latitude: 39.048043, longitude: -77.113131)
		case A13: return CLLocation(latitude: 39.062359, longitude: -77.1211129)
		case A14: return CLLocation(latitude: 39.084215, longitude: -77.146424)
		case A15: return CLLocation(latitude: 39.119819, longitude: -77.164921)
		case B01: return CLLocation(latitude: 38.89834, longitude: -77.021851)
		case B02: return CLLocation(latitude: 38.896084, longitude: -77.016643)
		case B03: return CLLocation(latitude: 38.897723, longitude: -77.006745)
		case B04: return CLLocation(latitude: 38.920741, longitude: -76.995984)
		case B05: return CLLocation(latitude: 38.933234, longitude: -76.994544)
		case B06: return CLLocation(latitude: 38.951777, longitude: -77.002174)
		case B07: return CLLocation(latitude: 38.975532, longitude: -77.017834)
		case B08: return CLLocation(latitude: 38.993841, longitude: -77.031321)
		case B09: return CLLocation(latitude: 39.015413, longitude: -77.042953)
		case B10: return CLLocation(latitude: 39.038558, longitude: -77.051098)
		case B11: return CLLocation(latitude: 39.061713, longitude: -77.05341)
		case B35: return CLLocation(latitude: 38.907407, longitude: -77.002961)
		case C01: return CLLocation(latitude: 38.898303, longitude: -77.028099)
		case C02: return CLLocation(latitude: 38.901316, longitude: -77.033652)
		case C03: return CLLocation(latitude: 38.901311, longitude: -77.03981)
		case C04: return CLLocation(latitude: 38.900599, longitude: -77.050273)
		case C05: return CLLocation(latitude: 38.896595, longitude: -77.07146)
		case C06: return CLLocation(latitude: 38.884574, longitude: -77.063108)
		case C07: return CLLocation(latitude: 38.869349, longitude: -77.054013)
		case C08: return CLLocation(latitude: 38.863045, longitude: -77.059507)
		case C09: return CLLocation(latitude: 38.85779, longitude: -77.050589)
		case C10: return CLLocation(latitude: 38.852985, longitude: -77.043805)
		case C12: return CLLocation(latitude: 38.814009, longitude: -77.053763)
		case C13: return CLLocation(latitude: 38.806474, longitude: -77.061115)
		case C14: return CLLocation(latitude: 38.800313, longitude: -77.071173)
		case C15: return CLLocation(latitude: 38.793841, longitude: -77.075301)
		case D01: return CLLocation(latitude: 38.893757, longitude: -77.028218)
		case D02: return CLLocation(latitude: 38.888022, longitude: -77.028232)
		case D03: return CLLocation(latitude: 38.884775, longitude: -77.021964)
		case D04: return CLLocation(latitude: 38.884958, longitude: -77.01586)
		case D05: return CLLocation(latitude: 38.884968, longitude: -77.005137)
		case D06: return CLLocation(latitude: 38.884124, longitude: -76.995334)
		case D07: return CLLocation(latitude: 38.880841, longitude: -76.985721)
		case D08: return CLLocation(latitude: 38.88594, longitude: -76.977485)
		case D09: return CLLocation(latitude: 38.898284, longitude: -76.948042)
		case D10: return CLLocation(latitude: 38.907734, longitude: -76.936177)
		case D11: return CLLocation(latitude: 38.91652, longitude: -76.915427)
		case D12: return CLLocation(latitude: 38.934411, longitude: -76.890988)
		case D13: return CLLocation(latitude: 38.947674, longitude: -76.872144)
		case E01: return CLLocation(latitude: 38.905604, longitude: -77.022256)
		case E02: return CLLocation(latitude: 38.912919, longitude: -77.022194)
		case E03: return CLLocation(latitude: 38.916489, longitude: -77.028938)
		case E04: return CLLocation(latitude: 38.928672, longitude: -77.032775)
		case E05: return CLLocation(latitude: 38.936077, longitude: -77.024728)
		case E06: return CLLocation(latitude: 38.951777, longitude: -77.002174)
		case E07: return CLLocation(latitude: 38.954931, longitude: -76.969881)
		case E08: return CLLocation(latitude: 38.965276, longitude: -76.956182)
		case E09: return CLLocation(latitude: 38.978523, longitude: -76.928432)
		case E10: return CLLocation(latitude: 39.011036, longitude: -76.911362)
		case F01: return CLLocation(latitude: 38.89834, longitude: -77.021851)
		case F02: return CLLocation(latitude: 38.893893, longitude: -77.021902)
		case F03: return CLLocation(latitude: 38.884775, longitude: -77.021964)
		case F04: return CLLocation(latitude: 38.876221, longitude: -77.017491)
		case F05: return CLLocation(latitude: 38.876588, longitude: -77.005086)
		case F06: return CLLocation(latitude: 38.862072, longitude: -76.995648)
		case F07: return CLLocation(latitude: 38.845334, longitude: -76.98817)
		case F08: return CLLocation(latitude: 38.840974, longitude: -76.975360)
		case F09: return CLLocation(latitude: 38.851187, longitude: -76.956565)
		case F10: return CLLocation(latitude: 38.843891, longitude: -76.932022)
		case F11: return CLLocation(latitude: 38.826995, longitude: -76.912134)
		case G01: return CLLocation(latitude: 38.890488, longitude: -76.938291)
		case G02: return CLLocation(latitude: 38.889757, longitude: -76.913382)
		case G03: return CLLocation(latitude: 38.886713, longitude: -76.893592)
		case G04: return CLLocation(latitude: 38.8913, longitude: -76.8682)
		case G05: return CLLocation(latitude: 38.9008, longitude: -76.8449)
		case J02: return CLLocation(latitude: 38.799193, longitude: -77.129407)
		case J03: return CLLocation(latitude: 38.766129, longitude: -77.168797)
		case K01: return CLLocation(latitude: 38.891499, longitude: -77.08391)
		case K02: return CLLocation(latitude: 38.886373, longitude: -77.096963)
		case K03: return CLLocation(latitude: 38.88331, longitude: -77.104267)
		case K04: return CLLocation(latitude: 38.882071, longitude: -77.111845)
		case K05: return CLLocation(latitude: 38.885841, longitude: -77.157177)
		case K06: return CLLocation(latitude: 38.90067, longitude: -77.189394)
		case K07: return CLLocation(latitude: 38.883015, longitude: -77.228939)
		case K08: return CLLocation(latitude: 38.877693, longitude: -77.271562)
		case N01: return CLLocation(latitude: 38.924478, longitude: -77.210167)
		case N02: return CLLocation(latitude: 38.920056, longitude: -77.223314)
		case N03: return CLLocation(latitude: 38.919749, longitude: -77.235192)
		case N04: return CLLocation(latitude: 38.92902, longitude: -77.241780)
		case N06: return CLLocation(latitude: 38.947753, longitude: -77.340179)
		case Train: return CLLocation()
		case No: return CLLocation()
		case Space: return CLLocation()
		}
	}
}