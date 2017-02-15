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
    var controlPoint1: CGPoint?
    var controlPoint2: CGPoint?
    
    var prev: WPTTrailStop?
    var next: WPTTrailStop?

    let level: WPTLevel
    var unlocked = false
    var completed = false
    
    init(target: CGPoint, controlPoint1: CGPoint?, controlPoint2: CGPoint?) {
        self.target = target
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
        self.level = WPTLevel("level file name", beaten: false)
    }
    
    // start node with nil control points
    convenience init(target: CGPoint) {
        self.init(target: target, controlPoint1: nil, controlPoint2: nil)
        self.unlocked = true
        self.completed = true
    }
}
