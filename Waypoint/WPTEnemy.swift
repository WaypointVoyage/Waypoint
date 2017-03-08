//
//  WPTEnemy.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTEnemy: WPTActor {
    let brain: WPTBrain
    let name: String
    
    init(_ enemyDict: [String:AnyObject]) {
        name = enemyDict["name"] as! String
        brain = WPTEnemyCatalog.brainsByName[enemyDict["brain"] as! String]!
        let ship = WPTShipCatalog.shipsByName[enemyDict["ship"] as! String]!
        super.init(ship: ship)
    }
}
