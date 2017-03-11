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
    static let type: WPTBrainStateType = WPTBrainStateType.NOTHING
    
    init() {
        super.init(name: String(describing: WPTDoNothingBS.self), type: WPTDoNothingBS.type)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        enemy.anchored = true
        enemy.targetRot = nil
    }
}
