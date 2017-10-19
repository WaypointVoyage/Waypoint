//
//  WPTTentacle2Wave.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 4 in the final boss
class WPTTentacle2Wave: WPTLevelWave {
    
    override init(_ waveDict: [String:AnyObject]) {
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        print("SETUP - WPTTentacle2Wave (4)")
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        print("FINISH - WPTTentacle2Wave (4)")
        return true
    }
}
