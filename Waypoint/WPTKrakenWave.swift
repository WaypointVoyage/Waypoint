//
//  WPTKrakenWave.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTKrakenWave: WPTLevelWave {
    
    let kraken = WPTKrakenNode()
    
    init() {
        super.init([:])
    }
    
    override func setup(scene: WPTLevelScene) {
        
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        // determine if the kraken is beaten
        return true
    }
}
