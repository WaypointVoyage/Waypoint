//
//  WPTWanderBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/18/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTWanderBS: WPTBrainState {
    static let type: WPTBrainStateType = WPTBrainStateType.NOTHING
    
    private var target: CGPoint? = nil
    private var lollygagging = false
    private var timeLollygagging: TimeInterval = 0
    private var maxTimeLollygagging: TimeInterval = 2
    
    init() {
        super.init(name: String(describing: WPTWanderBS.self), type: WPTWanderBS.type)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if lollygagging {
            timeLollygagging += seconds
            if timeLollygagging > maxTimeLollygagging {
                stopLollygagging()
            }
        } else {
            if target == nil { setNewTarget() }
            let dist = CGVector(start: enemy.position, end: target!).magnitude()
            if dist < brain.radiusOfEngagement / 2 {
                startLollygagging()
            } else {
                enemy.anchored = false
                enemy.facePoint(target!)
            }
        }
    }
    
    private func startLollygagging() {
        lollygagging = true
        timeLollygagging = 0
        target = nil
    }
    
    private func stopLollygagging() {
        lollygagging = false
    }
    
    private func setNewTarget() {
        if let terrain = (enemy.scene as? WPTLevelScene)?.terrain {
            target = terrain.randomPoint(borderWidth: 0, onLand: false)
        }
    }
}
