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
    var health: CGFloat
    var difficulty: CGFloat
    var completedLevels: [String]
    var progress: WPTPlayerProgress? = nil
    
    init(ship: WPTShip, shipName: String, completedLevels: [String]? = nil, difficulty: CGFloat) {
        self.shipName = shipName
        self.difficulty = difficulty
        self.completedLevels = completedLevels ?? [String]()
        self.health = ship.health
        super.init(ship: ship)
        
        progress = WPTPlayerProgress(player: self)
    }
    
    init(playerProgress: WPTPlayerProgress) {
        self.progress = playerProgress
        shipName = playerProgress.shipName
        health = playerProgress.health
        completedLevels = playerProgress.completedLevels
        self.difficulty = playerProgress.difficulty
        
        let ship = WPTShip(other: WPTShipCatalog.shipsByName[playerProgress.ship]!)
        for i in 0..<ship.cannonSet.cannons.count {
            let cannon = ship.cannonSet.cannons[i]
            cannon.hasCannon = playerProgress.cannonSet[i]!
        }
        super.init(ship: ship)
        
        self.cannonBall.image = playerProgress.cannonBallImage
        self.doubloons = playerProgress.doubloons
        
        for itemName in playerProgress.items {
            self.apply(item: WPTItemCatalog.itemsByName[itemName]!)
        }
    }
    
    override func apply(item: WPTItem) {
        let healthBefore = self.ship.health
        super.apply(item: item)
        let healthAfter = self.ship.health
        let healthChange = healthAfter - healthBefore
        if healthChange != 0 {
            self.health += healthChange
        }
    }
}
