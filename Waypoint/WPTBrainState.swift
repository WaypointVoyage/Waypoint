//
//  WPTBrainState.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTBrainState: GKState {
    let name: String
    
    init(name: String) {
        print("BrainState: \(name)")
        self.name = name
    }
}
