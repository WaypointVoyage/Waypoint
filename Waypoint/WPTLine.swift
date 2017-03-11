//
//  WPTLine.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/10/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLine {
    let p: CGPoint
    let q: CGPoint
    
    init(p: CGPoint, q: CGPoint) {
        self.p = p
        self.q = q
    }
    
    func intersects(circle: WPTCircle) -> Bool {
        let dist = self.distance(point: circle.center)
        return dist <= circle.radius
    }
    
    func distance(point: CGPoint) -> CGFloat {
        var num = point.x * (q.y - p.y)
        num -= point.y * (q.x - p.x)
        num += q.x * p.y - q.y * p.x
        num = abs(num)
        let den = sqrt(pow(q.y - p.y, 2) + pow(q.x - p.x, 2))
        return CGFloat(num / den)
    }
}
