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
    private var points: [(target: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint)]
    private var mapSize: CGSize
    
    public var startLocation: CGPoint {
        return startPoint
    }
    
    var treasureLocation: CGPoint? {
        return self.points.last?.target
    }
    
    init(startPoint: CGPoint, points: [(CGPoint, CGPoint, CGPoint)], mapSize: CGSize) {
        self.startPoint = startPoint
        self.points = [(CGPoint, CGPoint, CGPoint)]()
        self.mapSize = mapSize
        
        self.startPoint = scaled(point: self.startPoint)
        for pointSet in points {
            self.points.append((scaled(point: pointSet.0), scaled(point: pointSet.1), scaled(point: pointSet.2)))
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
    
    private func scaled(point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * mapSize.width, y: point.y * mapSize.height)
    }
}
