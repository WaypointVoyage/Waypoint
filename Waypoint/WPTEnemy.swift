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
    let terrainType: WPTEnemyTerrainType
    
    // behavior (values should be >= 0)
    let haste: CGFloat          // radius of engagement
    let aggression: CGFloat     // inner radius of obliviousness
    let awareness: CGFloat      // outer radius of obliviousness
    let caution: CGFloat        // radius of safety
    
    init(_ enemyDict: [String:AnyObject]) {
        name = enemyDict["name"] as! String
        self.awareness = enemyDict["awareness"] as! CGFloat
        self.aggression = enemyDict["aggression"] as! CGFloat
        self.haste = enemyDict["haste"] as! CGFloat
        self.caution = enemyDict["caution"] as! CGFloat
        brainTemplate = WPTEnemyCatalog.brainTemplatesByName[enemyDict["brain"] as! String]!
        let ship = WPTShipCatalog.shipsByName[enemyDict["ship"] as! String]!
        terrainType = WPTEnemyTerrainType.init(rawValue: enemyDict["terrainType"] as! String)!
        super.init(ship: ship)
        
        assertBehaviors()
    }
    
    private func assertBehaviors() {
        for behavior in [awareness, aggression, haste, caution] {
            assert(0 <= behavior)
        }
    }
}

enum WPTEnemyTerrainType: String {
    case land = "_LAND"
    case sea = "_SEA"
    case both = "_BOTH"
}
