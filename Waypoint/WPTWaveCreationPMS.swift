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
        guard let scene = (self.stateMachine as? WPTPuppetMaster)?.scene else { return; }
        
        for (enemy, quantity) in wave!.enemies {
            for _ in 0..<quantity {
                let enemyNode = WPTLevelEnemyNode(enemy: enemy, player: scene.player)
                var pos: CGPoint! = nil
                
                if enemy.terrainType == WPTEnemyTerrainType.land {
                    pos = scene.terrain.randomPoint(borderWidth: enemyNode.sprite.frame.width / 2, onLand: true, inCameraView: false)
                } else {
                    assert(scene.level.spawnVolumes.count > 0, "Cannot place water based enemies without a spawn volume!")
                    let spawnVol = scene.level.randomSpawnVolume()
                    var rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
                    let xpos = spawnVol.minX + rand * (spawnVol.width)
                    rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
                    let ypos = spawnVol.minY + rand * (spawnVol.height)
                    pos = CGPoint(x: xpos, y: ypos)
                }
                
                enemyNode.position = pos
                scene.terrain.addEnemy(enemyNode)
            }
        }
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
