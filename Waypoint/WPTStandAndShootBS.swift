//
//  WPTStandAndShootBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTStandAndShootBS: WPTBrainState {
    
    init() {
        super.init(name: String(describing: WPTStandAndShootBS.self), type: WPTBrainStateType.OFFENSE)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.enemy.facePoint(self.player.position)
    }
}
