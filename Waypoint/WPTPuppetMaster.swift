//
//  WPTPuppetMaster.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTPuppetMaster: GKStateMachine {
    weak var scene: WPTLevelScene!
    
    init(_ scene: WPTLevelScene) {
        self.scene = scene
        super.init(states: [
            WPTPlayerPrepPMS(), WPTWaveCreationPMS(), WPTWaveExecutionPMS(), WPTLevelBeatenPMS()
        ])
    }
    
    func start(levelBeaten: Bool) {
        if !enter(levelBeaten ? WPTLevelBeatenPMS.self : WPTPlayerPrepPMS.self) {
            NSLog("ERROR: Could not start WPTPuppetMaster!")
        }
    }
}
