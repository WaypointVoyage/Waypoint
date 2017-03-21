//
//  WPTLootSummary.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLootSummary: NSObject, NSCoding, Comparable {
    
    let shipName: String
    let doubloons: Int
    let date: Date
    let items: [String]
    
    init(player: WPTPlayer) {
        self.shipName = player.shipName
        self.doubloons = player.doubloons
        items = player.items.map { $0.name }
        
        date = Date()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.shipName = aDecoder.decodeObject(forKey: "shipName") as! String
        self.doubloons = aDecoder.decodeInteger(forKey: "doubloons")
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.items = aDecoder.decodeObject(forKey: "items") as! [String]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(shipName, forKey: "shipName")
        aCoder.encode(doubloons, forKey: "doubloons")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(items, forKey: "items")
    }
    
    static func ==(lhs: WPTLootSummary, rhs: WPTLootSummary) -> Bool {
        return lhs.doubloons == rhs.doubloons
    }
    
    static func <(lhs: WPTLootSummary, rhs: WPTLootSummary) -> Bool {
        return lhs.doubloons < rhs.doubloons
    }
}
