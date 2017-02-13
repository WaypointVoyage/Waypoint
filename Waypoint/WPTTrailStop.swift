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
    
    var levelFileNamed: String?
    var unlocked = false
    var completed = false
    
    var prev: WPTTrailStop?
    var next: WPTTrailStop?
    
    init(target: CGPoint, controlPoint1: CGPoint?, controlPoint2: CGPoint?) {
        self.target = target
        self.controlPoint1 = controlPoint1
        self.controlPoint2 = controlPoint2
    }
    
    convenience init(target: CGPoint) {
        self.init(target: target, controlPoint1: nil, controlPoint2: nil)
        self.unlocked = true
        self.completed = true
    }
    
    init(from: WPTTrailStop, scale: CGSize) {
        self.target = WPTTrailMap.scaled(from.target, mapSize: scale);
        if from.controlPoint1 != nil {
            self.controlPoint1 = WPTTrailMap.scaled(from.controlPoint1!, mapSize: scale)
        }
        if from.controlPoint2 != nil {
            self.controlPoint2 = WPTTrailMap.scaled(from.controlPoint2!, mapSize: scale)
        }
        self.unlocked = from.unlocked
    }
}
