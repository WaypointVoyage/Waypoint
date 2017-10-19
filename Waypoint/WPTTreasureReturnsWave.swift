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
    
    override init(_ waveDict: [String:AnyObject]) {
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        print("SETUP - WPTTreasureReturnsWave (6)")
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        print("FINISH - WPTTreasureReturnsWave (6)")
        return true
    }
}
