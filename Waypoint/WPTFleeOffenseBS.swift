//
//  WPTFleeOffenseBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/18/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTFleeOffenseBS: WPTBrainState {
    static let type: WPTBrainStateType = WPTBrainStateType.OFFENSE
    
    init() {
        super.init(name: String(describing: WPTFleeOffenseBS.self), type: WPTFleeOffenseBS.type)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let dist = self.enemy.distance(to: player);
        
        if dist < brain.radiusOfEngagement {
            // attack
            enemy.anchored = true
            self.aimAtPlayer()
            self.tryShoot()
        }
        else {
            // flee
            enemy.anchored = false
            let towardsPlayer = CGVector(start: enemy.position, end: player.position)
            let target = CGPoint(x: enemy.position.x - towardsPlayer.dx, y: enemy.position.y - towardsPlayer.dy)
            enemy.facePoint(target)
        }
    }
}
