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
        super.init(name: String(describing: WPTDoNothingBS.self), type: WPTPursueBS.type)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        let dist = self.enemy.distance(to: player)
        self.tryShoot()
        
        if enemy.anchored {
            self.aimAtPlayer()
            if dist > brain.outerRadiusOfObliviousness {
                enemy.anchored = false
            }
        } else {
            enemy.facePoint(player.position)
            if dist < brain.innerRadiusOfObliviousness {
                enemy.anchored = true
            }
        }        
    }
}
