//
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTWaveCreationPMS: GKState {
    private static let ENEMY_SPAWN_THROTTLE: TimeInterval = 0.3
    
    public private(set) var wave: WPTLevelWave? = nil
    private var ready = false
    
    private var enemyQueue = [WPTEnemy]()
    
    override func didEnter(from previousState: GKState?) {
        NSLog("Started WPTWaveCreationPMS")
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
        self.setupWave()
    }
    
    private func setupWave() {
        NSLog("setting up the wave")
        guard let scene = (self.stateMachine as? WPTPuppetMaster)?.scene else { return; }
        
        NSLog("calling specialized wave setup")
        self.wave!.setup(scene: scene)
        
        // start spawning enemies
        self.spawnEnemy(scene: scene, index: 0)
    }
    
    private func spawnEnemy(scene: WPTLevelScene, index: Int) {
        if index < self.wave!.enemies.count {
            let waveEnemy = self.wave!.enemies[index]
            NSLog("creating a \(waveEnemy.enemy.name)")
            
            let enemyNode = WPTLevelEnemyNode(enemy: waveEnemy.enemy, player: scene.player)
            enemyNode.give(item: scene.level.enemyBalanceItem)
            for item in waveEnemy.items {
                enemyNode.give(item: item)
            }
            enemyNode.updateHealth()

            NSLog("adding the enemy to the terrain")
            enemyNode.position = self.wave!.enemySpawnPosition(enemyNode)!
            scene.terrain.addEnemy(enemyNode)
            scene.run(SKAction.wait(forDuration: WPTWaveCreationPMS.ENEMY_SPAWN_THROTTLE)) {
                self.spawnEnemy(scene: scene, index: index + 1)
            }
        } else {
            NSLog("Done adding enemies")
            self.ready = true
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
