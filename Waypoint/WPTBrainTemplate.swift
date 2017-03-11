//
//  WPTBrainTemplate.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/10/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTBrainTemplate {
    let name: String
    var brainStates = [WPTBrainStateType:String]()
    
    init(_ brainDict: [String:AnyObject]) {
        name = brainDict["name"] as! String
        
        let stateDict = brainDict["brainStates"] as! [String:String]
        brainStates[WPTBrainStateType.NOTHING] = stateDict["nothing"]
        brainStates[WPTBrainStateType.OFFENSE] = stateDict["offense"]
        brainStates[WPTBrainStateType.DEFENSE] = stateDict["defense"]
        brainStates[WPTBrainStateType.FLEE] = stateDict["flee"]
    }
}
