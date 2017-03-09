//
//  WPTBrain.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTBrain: GKStateMachine {
    let name: String
    
    init(_ brainDict: [String:AnyObject]) {
        name = brainDict["name"] as! String
        
        var brainStates: Set<WPTBrainState> = Set<WPTBrainState>()
        for stateName in brainDict["brainStates"] as! [String] {
            brainStates.insert(WPTBrainStateFactory.get(stateName))
        }
        super.init(states: Array(brainStates))
    }
}
