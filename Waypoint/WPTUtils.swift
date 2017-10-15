//
//  WPTUtils.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/10/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

let CG_PI: CGFloat = CGFloat(Double.pi)

func clamp<T: Comparable>(_ value: inout T, min: T, max: T) {
    value = value < min ? min : value > max ? max : value
}

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func - (lhs: CGPoint, rhs: CGVector) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }
    
    static func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs * rhs.x, y: lhs * rhs.y)
    }
    
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    static func += (lhs: inout CGPoint, rhs: CGVector) {
        lhs.x += rhs.dx
        lhs.y += rhs.dy
    }
    
    func magnitude() -> CGFloat {
        return sqrt(pow(self.x, 2) + pow(self.y, 2))
    }
    
    func toVector() -> CGVector {
        return CGVector(dx: x, dy: y)
    }
}

extension CGVector {
    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    static func * (lhs: CGFloat, rhs: CGVector) -> CGVector {
        return CGVector(dx: lhs * rhs.dx, dy: lhs * rhs.dy)
    }
    
    init(start: CGPoint, end: CGPoint) {
        self.init(dx: end.x - start.x, dy: end.y - start.y)
    }
    
    func normalized() -> CGVector {
        let length = self.magnitude()
        return CGVector(dx: self.dx / length, dy: self.dy / length)
    }
    
    func magnitude() -> CGFloat {
        return sqrt(pow(self.dx, 2) + pow(self.dy, 2))
    }
    
    func dot(_ other: CGVector) -> CGFloat {
        return self.dx * other.dx + self.dy * other.dy
    }
    
    func angle(_ other: CGVector) -> CGFloat {
        return acos(self.dot(other) / (self.magnitude() * other.magnitude()))
    }
    
    func angle() -> CGFloat {
        var angle = self.angle(CGVector(dx: 1, dy: 0))
        if self.dy < 0 {
            angle += 2 * (CG_PI - angle)
        }
        return angle
    }
}

extension CGPath {
    static func fromPoints(_ points: [CGPoint]) -> CGPath {
        let result = UIBezierPath()
        result.move(to: points[0])
        for i in 1..<points.count {
            result.addLine(to: points[i])
        }
        return result.cgPath
    }
}
