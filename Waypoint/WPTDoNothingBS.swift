//
//  WPTDoNothingBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/10/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTDoNothingBS: WPTBrainState {
    private var radiusOfObliviousness: CGFloat? {
        if self.enemy.enemy.aggression <= 0 { return -1 }
        if self.enemy.enemy.aggression >= 1 { return nil }
        return self.enemy.enemy.aggression * 1000
    }
    
    init() {
        super.init(name: String(describing: WPTDoNothingBS.self), type: WPTBrainStateType.NOTHING)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let rad = radiusOfObliviousness {
            let dist = self.enemy.distance(to: self.player)
            if dist < rad {
                let _ = self.brain.transition(WPTBrainStateType.OFFENSE)
            }
        }
    }
}
