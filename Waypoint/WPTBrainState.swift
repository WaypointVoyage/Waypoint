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
    let type: WPTBrainStateType
    
    var brain: WPTBrain { return self.stateMachine as! WPTBrain }
    
    var enemy: WPTLevelEnemyNode {
        return (self.stateMachine as! WPTBrain).enemy
    }
    
    var player: WPTLevelPlayerNode {
        return (self.stateMachine as! WPTBrain).player
    }
    
    init(name: String, type: WPTBrainStateType) {
        self.name = name
        self.type = type
    }
}

enum WPTBrainStateType: String {
    case NOTHING = "_NOTHING"
    case OFFENSE = "_OFFENSE"
    case DEFENSE = "_DEFENSE"
    case FLEE = "_FLEE"
}
