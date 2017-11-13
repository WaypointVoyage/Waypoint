//
//  WPTSlowlyHealBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 11/12/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTSlowlyHealBS: WPTWanderBS {
    
    private var timer: TimeInterval = 0
    private static let HEAL_TIME: TimeInterval = 3.0
    
    private var healAmount: CGFloat? = nil
    private static let HEAL_PROPORTION: CGFloat = 0.15

    override init() {
        let name = String(describing: WPTSlowlyHealBS.self)
        super.init(name: name)
        
    }
   
    override func update(deltaTime sec: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {
        super.update(deltaTime: sec, healthLow: healthLow, distToPlayer: distToPlayer)
        
        if self.healAmount == nil {
            self.healAmount = WPTSlowlyHealBS.HEAL_PROPORTION * self.enemy.enemy.ship.health
        }

        self.timer += sec
        if self.timer > WPTSlowlyHealBS.HEAL_TIME {
            self.timer = 0
            self.enemy.doDamage(self.healAmount!)
        }
    }
}

