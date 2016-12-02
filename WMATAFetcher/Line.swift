//
//  Line.swift
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
#if os(iOS) || os(tvOS) || os(watchOS)
	import UIKit
	public typealias Color = UIColor
#elseif os(OSX)
	import Cocoa
	public typealias Color = NSColor
#endif

/// Represents each of the line colors in the WMATA system.
/// - Red
/// - Blue
/// - Yellow
/// - Orange
/// - Green
/// - Silver
/// - No passenger
public enum Line: String {
    /// Red
    case RD
	/// Blue
	case BL
	/// Yellow
	case YL
	/// Orange
	case OR
	/// Green
	case GR
	/// Silver
	case SV
	/// No passenger
	case NO
	
	/// The actual color of the line
    public var color : Color {
        switch self {
        case .RD: return Color.red
        case .BL: return Color(red: 80/255, green: 150/255, blue: 240/255, alpha: 1)
        case .YL: return Color.yellow
        case .OR: return Color.orange
        case .GR: return Color(red: 50/255, green: 220/255, blue: 50/255, alpha: 1)
        case .SV: return Color(red: 97/255, green: 97/255, blue: 97/255, alpha: 1)
        case .NO: return Color.clear
        }
    }
    
}
