//
//  WPTTrailMap.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTrailMap {
    private var startPoint: WPTTrailStop
    private var points: [WPTTrailStop]
    
    public var startLocation: CGPoint {
        return startPoint.target + WPTValues.heightShift
    }
    
    var treasureLocation: CGPoint? {
        return (self.points.last?.target)! + WPTValues.heightShift
    }
    
    public var stopCount: Int {
        return 1 + self.points.count
    }
    
    init(mapSize: CGSize, progress: WPTPlayerProgress) {
        let plistPath = Bundle.main.path(forResource: "trail_map", ofType: "plist")!
        let trailMapDict = NSDictionary(contentsOfFile: plistPath) as! [String: Any]
        let startPointDict = trailMapDict["startPoint"] as! [String: CGFloat]
        self.startPoint = WPTTrailStop(target: WPTTrailMap.scaled(CGPoint(x: startPointDict["x"]!, y: startPointDict["y"]!), mapSize: mapSize))
        
        self.points = [WPTTrailStop]()
        var prev: WPTTrailStop = self.startPoint
        let pointsArr = trailMapDict["points"] as! [[String: [String: CGFloat]]]
        for pointSetDict in pointsArr {
            let target = WPTTrailMap.scaled(CGPoint(x: pointSetDict["target"]!["x"]!, y: pointSetDict["target"]!["y"]!), mapSize: mapSize)
            let controlPoint1 = WPTTrailMap.scaled(CGPoint(x: pointSetDict["controlPoint1"]!["x"]!, y: pointSetDict["controlPoint1"]!["y"]!), mapSize: mapSize)
            let controlPoint2 = WPTTrailMap.scaled(CGPoint(x: pointSetDict["controlPoint2"]!["x"]!, y: pointSetDict["controlPoint2"]!["y"]!), mapSize: mapSize)
            
            let stop = WPTTrailStop(target: target, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            stop.prev = prev
            prev.next = stop
            prev = stop
            points.append(stop)
        }
    }
    
    subscript(index: Int) -> WPTTrailStop {
        get {
            assert(0 <= index && index <= self.points.count, "Invalid Index!")
            if index == 0 { return self.startPoint }
            return self.points[index - 1]
        }
    }
    
    func traversePoints(_ action: (Int, CGPoint, Bool) -> Void) {
        action(0, self.startPoint.target, true)
        var index = 1
        for pointSet in self.points {
            action(index, pointSet.target, pointSet.unlocked)
            index += 1
        }
    }
    
    func toCGPath() -> CGPath {
        let result = UIBezierPath()
        
        result.move(to: self.startPoint.target)
        for pointSet in points {
            result.addCurve(to: pointSet.target, controlPoint1: pointSet.controlPoint1!, controlPoint2: pointSet.controlPoint2!)
        }
        
        return result.cgPath
    }
    
    public static func scaled(_ point: CGPoint, mapSize: CGSize) -> CGPoint {
        return CGPoint(x: point.x * mapSize.width, y: point.y * mapSize.height);
    }
}
