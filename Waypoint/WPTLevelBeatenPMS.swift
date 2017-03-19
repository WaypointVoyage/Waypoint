//
//  WPTLevelBeatenPMS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTLevelBeatenPMS: GKState {
    override func didEnter(from previousState: GKState?) {
        print("Started WPTLevelBeatenPMS")
        
        // allow the player to dock at the port
        if let port = (self.stateMachine as? WPTPuppetMaster)?.scene.port {
            port.active = true
        }
    }
}
