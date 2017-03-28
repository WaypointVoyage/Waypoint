//
//  WPTStandAndShootBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTStandAndShootBS: WPTBrainState {
    static let type: WPTBrainStateType = WPTBrainStateType.OFFENSE
    
    init() {
        super.init(name: String(describing: WPTStandAndShootBS.self), type: WPTStandAndShootBS.type)
    }
    
    override func update(deltaTime sec: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {
        self.update(deltaTime: sec)
        
        // handle behavior
        self.enemy.aimCannons(node: self.player)
        self.tryShoot()
    }
}
