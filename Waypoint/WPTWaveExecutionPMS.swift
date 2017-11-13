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
    
    private var finishing = false
    
    override func didEnter(from previousState: GKState?) {
        NSLog("Started WPTWaveExecutionPMS")
        if let prev = previousState as? WPTWaveCreationPMS {
            wave = prev.wave
        }
        finishing = false
        assert(wave != nil, "Cannot use WPTWaveExecutionPMS with nil wave")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard !finishing else { return }
        
        wave!.update(seconds)
        if let pm = self.stateMachine as? WPTPuppetMaster {
            if wave!.isComplete(scene: pm.scene) {
                finishing = true
                if self.wave!.teardown(scene: pm.scene) {
                    if !pm.enter(self.wave!.next == nil ? WPTLevelBeatenPMS.self : WPTWaveCreationPMS.self) {
                        NSLog("ERROR: Could not transition out of WPTWaveExecutionPMS")
                    }
                }
            }
        }
    }
}
