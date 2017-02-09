//
//  WPTTrailMap.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTrailMap {
    private var startPoint: CGPoint
    private var points: [WPTTrailStop]
    
    public var startLocation: CGPoint {
        return startPoint
    }
    
    var treasureLocation: CGPoint? {
        return self.points.last?.target
    }
    
    public var stopCount: Int {
        return 1 + self.points.count
    }
    
    init(startPoint: CGPoint, points: [WPTTrailStop], mapSize: CGSize) {
        self.startPoint = startPoint
        self.points = [WPTTrailStop]()
        
        self.startPoint = WPTTrailStop.scaled(point: self.startPoint, mapSize: mapSize)
        for pointSet in points {
            self.points.append(WPTTrailStop(from: pointSet, scale: mapSize))
        }
    }
    
    func traversePoints(_ action: (Int, CGPoint, Bool) -> Void) {
        action(0, self.startLocation, true)
        var index = 1
        for pointSet in self.points {
            action(index, pointSet.target, pointSet.unlocked)
            index += 1
        }
    }
    
    func toCGPath() -> CGPath {
        let result = UIBezierPath()
        
        result.move(to: self.startPoint)
        for pointSet in points {
            result.addCurve(to: pointSet.target, controlPoint1: pointSet.controlPoint1, controlPoint2: pointSet.controlPoint2)
        }
        
        return result.cgPath
    }
}
