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
        print("SETUP - WPTKrakenWave (5)")
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        print("FINISH - WPTKrakenWave (5)")
        return true
    }
}
