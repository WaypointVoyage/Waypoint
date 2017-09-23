//
//  WPTTentacle1Wave.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 3 in the final boss
class WPTTentacle1Wave: WPTLevelWave {
    
    init() {
        super.init([:])
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        // determine if the kraken is beaten
        print("Kraken Tentacle 1")
        return true
    }
    
    override func enemySpawnPosition(_ enemy: WPTLevelEnemyNode) -> CGPoint? {
        if let pos = super.enemySpawnPosition(enemy) {
            return pos
        }
        
        // Hilary
        // Here is a good point to hook in custom spawning for the tentacles
        
        return nil
    }
}
