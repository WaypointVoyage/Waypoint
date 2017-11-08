//
//  WPTPlayerPrepPMS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTPlayerPrepPMS: GKState {
    private var prepClock: TimeInterval = 0
    
    override func didEnter(from previousState: GKState?) {
        NSLog("Started WPTPlayerPrepPMS")
        prepClock = 0
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        prepClock += seconds
        if prepClock > WPTValues.playerPrepTime {
            if let pm = self.stateMachine as? WPTPuppetMaster {
                if !pm.enter(pm.scene.level.waves.count <= 0 ? WPTLevelBeatenPMS.self : WPTWaveCreationPMS.self) {
                    NSLog("ERROR: Could not transition out of WPTPlayerPrepPMS")
                }
            }
        }
    }
}
