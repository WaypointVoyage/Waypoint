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
        /* load the path information */
        let plistPath = Bundle.main.path(forResource: "trail_map", ofType: "plist")!
        let trailMapDict = NSDictionary(contentsOfFile: plistPath) as! [String: Any]
        
        // start point
        let startPointDict = trailMapDict["startPoint"] as! [String: AnyObject]
        let startTarget = startPointDict["target"] as! [String: CGFloat]
        let startTargetPoint = WPTTrailMap.scaled(CGPoint(x: startTarget["x"]!, y: startTarget["y"]!), mapSize: mapSize)
        let startLevel = startPointDict["levelNamed"] as! String
        self.startPoint = WPTTrailStop(target: startTargetPoint, levelNamed: startLevel)
        
        // the rest of the points
        self.points = [WPTTrailStop]()
        var prev: WPTTrailStop = self.startPoint
        let pointsArr = trailMapDict["points"] as! [[String: AnyObject]]
        for pointDict in pointsArr {
            
            // level name
            let levelNamed = pointDict["levelNamed"] as! String
            
            // target point
            let targetDict = pointDict["target"] as! [String:CGFloat]
            let target = CGPoint(x: targetDict["x"]!, y: targetDict["y"]!)
            let scaledTarget = WPTTrailMap.scaled(target, mapSize: mapSize)
            
            // control point 1
            let c1Dict = pointDict["controlPoint1"] as! [String:CGFloat]
            let c1 = CGPoint(x: c1Dict["x"]!, y: c1Dict["y"]!)
            let scaledC1 = WPTTrailMap.scaled(c1, mapSize: mapSize)
            
            // control point 2
            let c2Dict = pointDict["controlPoint2"] as! [String:CGFloat]
            let c2 = CGPoint(x: c2Dict["x"]!, y: c2Dict["y"]!)
            let scaledC2 = WPTTrailMap.scaled(c2, mapSize: mapSize)
            
            let stop = WPTTrailStop(target: scaledTarget, controlPoint1: scaledC1, controlPoint2: scaledC2, levelNamed: levelNamed)
            
            // linked list setup
            stop.prev = prev
            prev.next = stop
            prev = stop
            
            points.append(stop)
        }
        
        /* load player progress */
        var statusStop: WPTTrailStop? = self.startPoint
        while statusStop != nil && progress.completedLevels.contains(statusStop!.level!.name) {
            statusStop!.completed = true
            statusStop!.unlocked = true
            statusStop = statusStop!.next
        }
        if statusStop != nil {
            statusStop!.unlocked = true
        }
    }
    
    subscript(index: Int) -> WPTTrailStop {
        get {
            assert(0 <= index && index <= self.points.count, "Invalid Index!")
            if index == 0 { return self.startPoint }
            return self.points[index - 1]
        }
    }
    
    func traversePoints(_ action: (Int, CGPoint, Bool, Bool) -> Void) {
        action(0, self.startPoint.target, self.startPoint.unlocked, self.startPoint.completed)
        var index = 1
        for pointSet in self.points {
            action(index, pointSet.target, pointSet.unlocked, pointSet.completed)
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
