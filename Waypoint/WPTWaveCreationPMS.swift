//
//  WPTWaveCreationPMS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTWaveCreationPMS: GKState {
    public private(set) var wave: WPTLevelWave? = nil
    private var ready = false
    
    override func didEnter(from previousState: GKState?) {
        print("Started WPTWaveCreationPMS")
        ready = false
        
        if let prev = previousState as? WPTWaveExecutionPMS {
            wave = prev.wave!.next
        } else {
            if let scene = (self.stateMachine as? WPTPuppetMaster)?.scene {
                wave = scene.level.waves[0]
            }
        }
        assert(wave != nil, "Cannot use WPTWaveCreationPMS with a nil wave")
        
        // allows the setup to happen in the background
        OperationQueue().addOperation {
            self.setupWave()
            OperationQueue.main.addOperation {
                self.ready = true
            }
        }
    }
    
    private func setupWave() {
        print("setting up the wave")
        guard let scene = (self.stateMachine as? WPTPuppetMaster)?.scene else { return; }
        
        for (enemy, quantity) in wave!.enemies {
            for _ in 0..<quantity {
                print("creating a \(enemy)")
                let enemyNode = WPTLevelEnemyNode(enemy: enemy, player: scene.player)
                enemyNode.position = self.wave!.enemySpawnPosition(enemyNode)!
                print("adding the enemy to the terrain")
                scene.terrain.addEnemy(enemyNode)
            }
        }
        
        print("calling specialized wave setup")
        self.wave!.setup(scene: scene)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if ready {
            if let pm = self.stateMachine as? WPTPuppetMaster {
                if !pm.enter(WPTWaveExecutionPMS.self) {
                    NSLog("ERROR: could not switch to WPTWaveExecution")
                }
            }
        }
    }
}
