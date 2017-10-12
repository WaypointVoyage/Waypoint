//
//  WPTTreasureReturnsWave.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 6 in the final boss
class WPTTreasureReturnsWave: WPTLevelWave {
    
    init() {
        super.init([:])
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        // determine if the kraken is beaten
        print("Treasure Returns")
        return true
    }
}
