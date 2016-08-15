//
//  Line.swift
//  DCMetro
//
//  Created by Christopher Rung on 5/12/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
	import UIKit
	public typealias Color = UIColor
#elseif os(OSX)
	import Cocoa
	public typealias Color = NSColor
#endif

enum Line: String {
    
    case RD, BL, YL, OR, GR, SV, NO
    
    var color : Color {
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