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
    
    override func update(deltaTime sec: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {
        self.update(deltaTime: sec)
        
        if distToPlayer < brain.radiusOfEngagement {
            // attack
            enemy.anchored = true
            self.enemy.aimCannons(node: self.player)
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
