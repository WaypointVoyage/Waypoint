//
//  WPTPlayerProgress.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/13/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPlayerProgress: NSObject, NSCoding {
    // player stuff
    let shipName: String            // think of this as a name a person would give their ship
    let healthSnapshot: CGFloat
    let difficulty: CGFloat         // determines difficulty scaling, this changes when a level is earned
    let completedLevels: [String]
    
    var levelDockInventory: [String:[ItemWrapper]]
    
    // actor stuff
    let ship: String                // think of this as the 'make and model' of ship that is used
    let cannonBallImage: String
    let doubloons: Int
    var items: [String]
    var cannonSet: [Int:Bool]
    
    func print() {
        NSLog("Player Progress:")
        NSLog("  shipName: \(self.shipName)")
        NSLog("  healthSnapshot: \(self.healthSnapshot)")
        NSLog("  difficulty: \(self.difficulty)")
        NSLog("  completedLevels: \(self.completedLevels)")
        NSLog("  ship: \(self.ship)")
        NSLog("  cannonBallImage: \(self.cannonBallImage)")
        NSLog("  doubloons: \(self.doubloons)")
        NSLog("  items: \(self.items)")
        NSLog("  cannonSet: \(self.cannonSet)")
    }

    init(player: WPTPlayer) {
        self.difficulty = player.difficulty
        self.shipName = player.shipName
        self.healthSnapshot = player.ship.health
        self.completedLevels = player.completedLevels
        self.ship = player.ship.name
        self.cannonBallImage = player.cannonBall.image
        self.doubloons = 0
        self.items = player.items.map { (item) -> String in return item.name }
        var cannonSetDict = [Int:Bool]()
        for i in 0..<player.ship.cannonSet.cannons.count {
            let cannon = player.ship.cannonSet.cannons[i]
            cannonSetDict[i] = cannon.hasCannon
        }
        self.cannonSet = cannonSetDict
        
        self.levelDockInventory = [String:[ItemWrapper]]()
    }
    
    init(playerNode: WPTLevelPlayerNode) {
        self.difficulty = playerNode.player.difficulty
        shipName = playerNode.player.shipName
        self.healthSnapshot = playerNode.health
        completedLevels = playerNode.player.completedLevels
        ship = playerNode.player.ship.name
        cannonBallImage = playerNode.player.cannonBall.image
        doubloons = playerNode.doubloons
        items = playerNode.player.items.map { (item) -> String in return item.name }
        var cannonSetDict = [Int:Bool]()
        for i in 0..<playerNode.player.ship.cannonSet.cannons.count {
            let cannon = playerNode.player.ship.cannonSet.cannons[i]
            cannonSetDict[i] = cannon.hasCannon
        }
        cannonSet = cannonSetDict
        
        self.levelDockInventory = [String:[ItemWrapper]]()
    }
    
    init(shipName: String, ship: String, health: CGFloat? = nil, difficulty: CGFloat = 1.0, completedLevels: [String]? = nil, cannonBallImage: String? = nil, doubloons: Int = 0, items: [String]? = nil, cannonSet: [Int:Bool]?, levelDockInventory: [String:[ItemWrapper]]? = nil) {
        self.shipName = shipName
        self.ship = ship
        self.difficulty = difficulty
        
        let shipModel = WPTShipCatalog.shipsByName[ship]!
        if let givenHealth: CGFloat = health {
            assert(givenHealth <= shipModel.health, "Invalid health was given")
            self.healthSnapshot = givenHealth
        } else {
            self.healthSnapshot = shipModel.health
        }
        
        self.completedLevels = completedLevels == nil ? [String]() : completedLevels!
        
        self.cannonBallImage = cannonBallImage == nil ? WPTCannonBall.DEFAULT_IMAGE_NAME : cannonBallImage!
        self.doubloons = doubloons
        self.items = items == nil ? [String]() : items!
        
        var tmpCannonSet = [Int:Bool]()
        if let givenCannons: [Int:Bool] = cannonSet {
            tmpCannonSet = givenCannons
        } else {
            for i in 0..<shipModel.cannonSet.cannons.count {
                tmpCannonSet[i] = shipModel.cannonSet.cannons[i].hasCannon
            }
        }
        self.cannonSet = tmpCannonSet
        
        if let givenInventory = levelDockInventory {
            self.levelDockInventory = givenInventory
        } else {
            self.levelDockInventory = [String:[ItemWrapper]]()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.shipName = aDecoder.decodeObject(forKey: "shipName") as! String
        self.healthSnapshot = aDecoder.decodeObject(forKey: "health") as! CGFloat
        self.difficulty = aDecoder.decodeObject(forKey: "difficulty") as! CGFloat
        self.completedLevels = aDecoder.decodeObject(forKey: "completedLevels") as! [String]
        self.ship = aDecoder.decodeObject(forKey: "ship") as! String
        self.cannonBallImage = aDecoder.decodeObject(forKey: "cannonBallImage") as! String
        self.doubloons = aDecoder.decodeInteger(forKey: "doubloons")
        self.items = aDecoder.decodeObject(forKey: "items") as! [String]
        self.cannonSet = aDecoder.decodeObject(forKey: "cannonSet") as! [Int:Bool]
        self.levelDockInventory = aDecoder.decodeObject(forKey: "levelDockInventory") as! [String:[ItemWrapper]]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(shipName, forKey: "shipName")
        aCoder.encode(healthSnapshot, forKey: "health")
        aCoder.encode(difficulty, forKey: "difficulty")
        aCoder.encode(completedLevels, forKey: "completedLevels")
        aCoder.encode(ship, forKey: "ship")
        aCoder.encode(cannonBallImage, forKey: "cannonBallImage")
        aCoder.encode(doubloons, forKey: "doubloons")
        aCoder.encode(items, forKey: "items")
        aCoder.encode(cannonSet, forKey: "cannonSet")
        aCoder.encode(levelDockInventory, forKey: "levelDockInventory")
    }
}
