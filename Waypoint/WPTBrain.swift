//
//  WPTBrain.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTBrain {
    let name: String
    
    init(_ brainDict: [String:AnyObject]) {
        name = brainDict["name"] as! String
    }
}
