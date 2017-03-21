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
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.shipName = aDecoder.decodeObject(forKey: "shipName") as! String
        self.health = aDecoder.decodeObject(forKey: "health") as! CGFloat
        self.completedLevels = aDecoder.decodeObject(forKey: "completedLevels") as! [String]
        self.ship = aDecoder.decodeObject(forKey: "ship") as! String
        self.cannonBallImage = aDecoder.decodeObject(forKey: "cannonBallImage") as! String
        self.doubloons = aDecoder.decodeInteger(forKey: "doubloons")
        self.items = aDecoder.decodeObject(forKey: "items") as! [String]
        self.cannonSet = aDecoder.decodeObject(forKey: "cannonSet") as! [Int:Bool]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(shipName, forKey: "shipName")
        aCoder.encode(health, forKey: "health")
        aCoder.encode(completedLevels, forKey: "completedLevels")
        aCoder.encode(ship, forKey: "ship")
        aCoder.encode(cannonBallImage, forKey: "cannonBallImage")
        aCoder.encode(doubloons, forKey: "doubloons")
        aCoder.encode(items, forKey: "items")
        aCoder.encode(cannonSet, forKey: "cannonSet")
    }
}
