//
//  WPTItem.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/3/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTItem {
    let name: String        // unique item name
    let imageName: String   // the name of the image file (without extension)
    
    let tier: WPTItemTier   // the item type
    let multiplicity: Int?  // the number of times the item's effects can be applied to an actor (nil or <= 0 is unlimited)
    let value: Int          // value in doubloons
    let prevalence: Int     // how common is this item? > 0, relative to other items
    
    init(name: String, imageName: String, tier: WPTItemTier, multiplicity: Int?, value: Int, prevalence: Int) {
        self.name = name
        self.imageName = imageName
        self.tier = tier
        self.multiplicity = multiplicity
        self.value = value
        self.prevalence = prevalence
    }
    
    init(_ itemDict: [String:AnyObject]) {
        self.name = itemDict["name"] as! String
        self.imageName = itemDict["imageName"] as! String
        self.tier = WPTItemTier.init(rawValue: itemDict["tier"] as! String)!
        self.multiplicity = itemDict["multiplicity"] as? Int
        self.value = itemDict["value"] as! Int
        self.prevalence = itemDict["prevalence"] as! Int
    }
    
    init(asCurrency itemDict: [String:AnyObject]) {
        self.name = itemDict["name"] as! String
        self.imageName = itemDict["imageName"] as! String
        self.tier = WPTItemTier.currency
        self.multiplicity = nil
        self.value = itemDict["value"] as! Int
        self.prevalence = itemDict["prevalence"] as! Int
    }
    
    init(asRepair itemDict: [String:AnyObject]) {
        self.name = itemDict["name"] as! String
        self.imageName = itemDict["imageName"] as! String
        self.tier = WPTItemTier.repair
        self.multiplicity = nil
        self.value = -1
        self.prevalence = itemDict["prevalence"] as! Int
    }
    
    init(asStatModifier itemDict: [String:AnyObject]) {
        self.name = itemDict["name"] as! String
        self.imageName = itemDict["imageName"] as! String
        self.tier = WPTItemTier.statModifier
        self.multiplicity = itemDict["multiplicity"] as? Int
        self.value = itemDict["value"] as! Int
        self.prevalence = itemDict["prevalence"] as! Int
    }
}

enum WPTItemTier: String {
    case currency = "CURRENCY"
    case repair = "REPAIR"
    case statModifier = "STAT_MODIFIER"
}
