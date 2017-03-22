//
//  WPTPursueBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/11/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTPursueBS: WPTBrainState {
    static let type: WPTBrainStateType = WPTBrainStateType.OFFENSE
    
    init() {
        super.init(name: String(describing: WPTPursueBS.self), type: WPTPursueBS.type)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let dist = self.enemy.distance(to: player)
        self.tryShoot()
        
        if enemy.anchored {
            // priority on firing at the player
            self.enemy.aimCannons(actor: self.player)
            if dist > brain.radiusOfEngagement {
                enemy.anchored = false
            }
        } else {
            // priority on approaching the player
            enemy.facePoint(player.position)
            if dist < brain.radiusOfEngagement {
                enemy.anchored = true
            }
        }
    }
}
