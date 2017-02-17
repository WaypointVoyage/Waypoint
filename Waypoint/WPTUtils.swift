//
//  WPTUtils.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/10/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

func clamp<T: Comparable>(_ value: inout T, min: T, max: T) {
    value = value < min ? min : value > max ? max : value
}

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
