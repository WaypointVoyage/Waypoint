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
    var health: CGFloat
    let difficulty: CGFloat         // determines difficulty scaling, this changes when a level is earned
    let completedLevels: [String]
    
    var levelDockInventory: [String:[ItemWrapper]]
    
    // actor stuff
    let ship: String                // think of this as the 'make and model' of ship that is used
    let cannonBallImage: String
    let doubloons: Int
    var items: [String]
    var cannonSet: [Int:Bool]
    
    init(player: WPTPlayer) {
        self.difficulty = player.difficulty
        shipName = player.shipName
        health = player.health
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
        
        self.levelDockInventory = [String:[ItemWrapper]]()
    }
    
    init(shipName: String, ship: String, health: CGFloat? = nil, difficulty: CGFloat = 1.0, completedLevels: [String]? = nil, cannonBallImage: String? = nil, doubloons: Int = 0, items: [String]? = nil, cannonSet: [Int:Bool]?, levelDockInventory: [String:[ItemWrapper]]? = nil) {
        self.shipName = shipName
        self.ship = ship
        self.difficulty = difficulty
        
        let shipModel = WPTShipCatalog.shipsByName[ship]!
        if let givenHealth: CGFloat = health {
            assert(givenHealth <= shipModel.health, "Invalid health was given")
            self.health = givenHealth
        } else {
            self.health = shipModel.health
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
        self.health = aDecoder.decodeObject(forKey: "health") as! CGFloat
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
        aCoder.encode(health, forKey: "health")
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
