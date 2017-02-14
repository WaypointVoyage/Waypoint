//
//  WPTTrailMapNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import UIKit
import GameplayKit

class WPTTrailMapNode: SKNode {
    
    var trailMap: WPTTrailMap?
    private let progress: WPTPlayerProgress
    
    let trailShader = SKShader(fileNamed: "trail_shader.fsh")
    let unlockedMarkerTexture = SKTexture(imageNamed: "blue_circle")
    let lockedMarkerTexture = SKTexture(imageNamed: "red_circle")
    let treasureMarkerTexture = SKTexture(imageNamed: "x_marks_the_spot")
    
    private var markers = [SKSpriteNode]()
    
    init(progress: WPTPlayerProgress) {
        self.progress = progress
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func position(for scene: WPTScene) {
        self.removeAllChildren()
        
        let h = scene.frame.width / WPTValues.maxAspectRatio
        let ymin = (scene.frame.height - h) / 2.0;
        self.position = CGPoint(x: 0, y: ymin)
        
        self.trailMap = WPTTrailMap(mapSize: CGSize(width: scene.frame.width, height: h), progress: self.progress)
        let trail = SKShapeNode(path: self.trailMap!.toCGPath())
        trail.lineWidth = 2.5
        trail.strokeColor = .clear
        trail.strokeShader = trailShader
        
        self.addChild(trail)
        
        self.markers.removeAll()
        self.trailMap!.traversePoints({
            (index, point, isUnlocked, isCompleted) in
            
            var texture = isCompleted ? unlockedMarkerTexture : lockedMarkerTexture
            
            var scale: CGSize?
            switch (index) {
            case 0:
                let scaleSize = 0.08 * WPTValues.usableScreenHeight
                scale = CGSize(width: scaleSize, height: scaleSize)
            case self.trailMap!.stopCount - 1:
                let scaleSize = 0.15 * WPTValues.usableScreenHeight
                scale = CGSize(width: scaleSize, height: scaleSize)
                texture = treasureMarkerTexture
            default:
                let scaleSize = 0.06 * WPTValues.usableScreenHeight
                scale = CGSize(width: scaleSize, height: scaleSize)
            }
            
            let marker = SKSpriteNode(texture: texture)
            marker.position = point
            marker.scale(to: scale!)
            marker.zPosition = 2
            self.markers.append(marker)
            self.addChild(marker)
        })
    }
    
    func getStopIndex(for touch: UITouch) -> Int? {
        var target: Int? = nil
        self.trailMap!.traversePoints({
            (index, point, isUnlocked, isCompleted) in
            if (target == nil) {
                let marker = self.markers[index]
                if marker.contains(touch.location(in: self)) {
                    target = index
                }
            }
        })
        return target
    }
    
    func getConnectedPath(from start: Int, to target: Int) -> CGPath? {
        if (start == target) { return nil }
        let startStop = self.trailMap![start]
        let targetStop = self.trailMap![target]
        return start < target ? getForewardPath(start: startStop, target: targetStop, checkLocked: false)
            : getBackwardPath(start: startStop, target: targetStop, checkLocked: false)
    }
    
    private func getForewardPath(start: WPTTrailStop, target: WPTTrailStop, checkLocked: Bool = true) -> CGPath? {
        let path = UIBezierPath()
        var current = start
        path.move(to: current.target + WPTValues.heightShift)
        
        while current !== target {
            current = current.next!
            if (checkLocked && !current.unlocked) {
                return current.prev! === start ? nil : path.cgPath
            }
            
            let target = current.target + WPTValues.heightShift
            let c1 = current.controlPoint1! + WPTValues.heightShift
            let c2 = current.controlPoint2! + WPTValues.heightShift
            path.addCurve(to: target, controlPoint1: c1, controlPoint2: c2)
        }
        
        return path.cgPath
    }
    
    private func getBackwardPath(start: WPTTrailStop, target: WPTTrailStop, checkLocked: Bool = true) -> CGPath? {
        let path = UIBezierPath()
        var current = start
        path.move(to: current.target + WPTValues.heightShift)
        
        while current !== target {
            current = current.prev!
            if (checkLocked && !current.unlocked) {
                return current.next! === start ? nil : path.cgPath
            }
            
            let target = current.target + WPTValues.heightShift
            let c1 = current.next!.controlPoint2! + WPTValues.heightShift
            let c2 = current.next!.controlPoint1! + WPTValues.heightShift
            path.addCurve(to: target, controlPoint1: c1, controlPoint2: c2)
        }
        
        return path.cgPath
    }
}
