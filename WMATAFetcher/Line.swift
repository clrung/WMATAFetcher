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

public enum Line: String {
    
    case RD, BL, YL, OR, GR, SV, NO
    
    public var color : Color {
        switch self {
        case .RD: return Color.redColor()
        case .BL: return Color(red: 80/255, green: 150/255, blue: 240/255, alpha: 1)
        case .YL: return Color.yellowColor()
        case .OR: return Color.orangeColor()
        case .GR: return Color(red: 50/255, green: 220/255, blue: 50/255, alpha: 1)
        case .SV: return Color(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        case .NO: return Color.clearColor()
        }
    }
    
}