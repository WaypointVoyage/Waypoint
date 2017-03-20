//
//  WPTPlayer.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPlayer: WPTActor {
    let shipName: String
    var health: CGFloat? = nil
    var completedLevels: [String]
    
    init(ship: WPTShip, shipName: String, completedLevels: [String]? = nil) {
        self.shipName = shipName
        self.completedLevels = completedLevels ?? [String]()
        super.init(ship: ship)
    }
    
    init(playerPorgress: WPTPlayerProgress) {
        shipName = playerPorgress.shipName
        health = playerPorgress.health
        completedLevels = playerPorgress.completedLevels
        
        let ship = WPTShipCatalog.shipsByName[playerPorgress.ship]!
        for i in 0..<ship.cannonSet.cannons.count {
            let cannon = ship.cannonSet.cannons[i]
            cannon.hasCannon = playerPorgress.cannonSet[i]!
        }
        super.init(ship: ship)
        
        self.cannonBall.image = playerPorgress.cannonBallImage
        self.doubloons = playerPorgress.doubloons
        
        for itemName in playerPorgress.items {
            self.apply(item: WPTItemCatalog.itemsByName[itemName]!)
        }
    }
}
