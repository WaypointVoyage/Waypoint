//
//  WPTStandAndShootBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTStandAndShootBS: WPTBrainState {
    
    private var radiusOfObliviousness: CGFloat? {
        if self.enemy.enemy.aggression >= 1 { return nil }
        if self.enemy.enemy.aggression <= 0 { return -1 }
        return self.enemy.enemy.aggression * 1200
    }
    
    init() {
        super.init(name: String(describing: WPTStandAndShootBS.self), type: WPTBrainStateType.OFFENSE)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // handle behavior
        self.enemy.facePoint(self.player.position)
        self.tryShoot()
        
        // check for transition
        if let rad = self.radiusOfObliviousness {
            let dist = self.enemy.distance(to: self.player)
            if dist > rad {
                let _ = self.brain.transition(WPTBrainStateType.NOTHING)
            }
        }
    }
    
    private func tryShoot() {
        guard enemy.fireRateMgr.canFire else { return; }
        
        for cannon in self.enemy.cannonNodes {
            let rot = enemy.zRotation + cannon.zRotation
            let dir = CGPoint(x: cos(rot), y: sin(rot))
            let toPlayer = CGVector(dx: player.position.x - enemy.position.x, dy: player.position.y - enemy.position.y).normalized()
            if dir.toVector().dot(toPlayer) >= 0 {
                let line = WPTLine(p: enemy.position, q: enemy.position + dir)
                let circle = WPTCircle(center: player.position, radius: player.sprite.frame.size.width / 2)
                if line.intersects(circle: circle) {
                    self.enemy.fireCannons()
                    break
                }
            }
        }
    }
}
