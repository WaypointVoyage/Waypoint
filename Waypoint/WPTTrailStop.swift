//
//  WPTTrailStop.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTrailStop {
    var target: CGPoint
    var controlPoint1: CGPoint
    var controlPoint2: CGPoint
    
    var unlocked = false
    
    init(target: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.target = target
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
    }
    
    init(from: WPTTrailStop, scale: CGSize) {
        self.target = WPTTrailStop.scaled(point: from.target, mapSize: scale);
        self.controlPoint1 = WPTTrailStop.scaled(point: from.controlPoint1, mapSize: scale)
        self.controlPoint2 = WPTTrailStop.scaled(point: from.controlPoint2, mapSize: scale)
        self.unlocked = from.unlocked
    }
    
    public static func scaled(point: CGPoint, mapSize: CGSize) -> CGPoint {
        return CGPoint(x: point.x * mapSize.width, y: point.y * mapSize.height);
    }
}
