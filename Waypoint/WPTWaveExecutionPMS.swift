//
//  WPTWaveExecutionPMS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTWaveExecutionPMS: GKState {
    public private(set) var wave: WPTLevelWave? = nil
    
    override func didEnter(from previousState: GKState?) {
        print("Started WPTWaveExecutionPMS")
        if let prev = previousState as? WPTWaveCreationPMS {
            wave = prev.wave
        }
        assert(wave != nil, "Cannot use WPTWaveExecutionPMS with nil wave")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let pm = self.stateMachine as? WPTPuppetMaster {
            if pm.scene.terrain.enemies.count <= 0 {
                if !pm.enter(wave!.next == nil ? WPTLevelBeatenPMS.self : WPTWaveCreationPMS.self) {
                    NSLog("ERROR: Could not transition out of WPTWaveExecutionPMS")
                }
            }
        }
    }
}
