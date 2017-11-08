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

func randomNumber(min: CGFloat, max: CGFloat) -> CGFloat {
    let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
    return min + rand * (max - min)
}

// Generates a normally distributed random number
// http://www.design.caltech.edu/erik/Misc/Gaussian.html
func randomNormalSample(mean: Float, stddev: Float) -> Float {
    let x1 = Float(randomNumber(min: 0, max: 1))
    let x2 = Float(randomNumber(min: 0, max: 1))
    let y = sqrt(-2 * log(x1)) * cos(2 * Float.pi * x2)
    return mean + stddev * y
}

func clamp<T: Comparable>(_ value: inout T, min: T, max: T) {
    value = value < min ? min : value > max ? max : value
}

func zRotationToRadians(_ zRotation: CGFloat) -> CGFloat {
    var zRot = zRotation
    let twopi = 2 * CG_PI
    while zRot < 0 { zRot += twopi }
    while zRot >= twopi { zRot -= twopi }
    return zRot
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
    
    init(radians angle: CGFloat) {
        self.init(dx: cos(angle), dy: sin(angle))
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
        
        if !points.isEmpty {
            result.move(to: points[0])
            for i in 1..<points.count {
                result.addLine(to: points[i])
            }
        }
        
        return result.cgPath
    }
}
