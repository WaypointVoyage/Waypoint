//
//  WPTKrakenWave.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 5 in the final boss
class WPTKrakenWave: WPTLevelWave {
    
    override init(_ waveDict: [String: AnyObject]) {
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        // determine if the kraken is beaten
        print("Kraken Full")
        return true
    }
    
    override func enemySpawnPosition(_ enemy: WPTLevelEnemyNode) -> CGPoint? {
        if let pos = super.enemySpawnPosition(enemy) {
            return pos
        }
        
        // Hilary
        // spawn kraken head here
        
        return nil
    }
}
