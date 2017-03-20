//
//  WPTPlayerProgress.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/13/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPlayerProgress {
    // player stuff
    let shipName: String
    let health: CGFloat
    let completedLevels: [String]
    
    // actor stuff
    let ship: String
    let cannonBallImage: String
    let doubloons: Int
    let items: [String]
    let cannonSet: [Int:Bool]
    
    init(player: WPTPlayer) {
        shipName = player.shipName
        health = player.health!
        completedLevels = player.completedLevels
        ship = player.ship.name
        cannonBallImage = player.cannonBall.image
        doubloons = player.doubloons
        items = player.items.map { (item) -> String in return item.name }
        var cannonSetDict = [Int:Bool]()
        for i in 0..<player.ship.cannonSet.cannons.count {
            let cannon = player.ship.cannonSet.cannons[i]
            cannonSetDict[i] = cannon.hasCannon
        }
        cannonSet = cannonSetDict
    }
    
}
