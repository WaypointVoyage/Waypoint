//
//  WPTEnemy.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTEnemy: WPTActor {
    let brainTemplate: WPTBrainTemplate
    let name: String
    
    // behavior
    let aggression: CGFloat // [0, 1] -> 0: passive wont attack, 1: will always attack
    
    init(_ enemyDict: [String:AnyObject]) {
        name = enemyDict["name"] as! String
        self.aggression = enemyDict["aggression"] as! CGFloat
        brainTemplate = WPTEnemyCatalog.brainTemplatesByName[enemyDict["brain"] as! String]!
        let ship = WPTShipCatalog.shipsByName[enemyDict["ship"] as! String]!
        super.init(ship: ship)
    }
}
