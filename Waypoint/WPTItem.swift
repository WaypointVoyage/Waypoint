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
    let description: String?
    let imageName: String   // the name of the image file (without extension)
    
    let tier: WPTItemTier   // the item type
    let multiplicity: Int?  // the number of times the item's effects can be applied to an actor (nil or <= 0 is unlimited)
    let value: Int          // value in doubloons
    let prevalence: Int     // how common is this item? > 0, relative to other items
    
    // stat modifiers (added to ship stat scales)
    public private(set) var speedModifier: CGFloat?
    public private(set) var damageModifier: CGFloat?
    public private(set) var healthModifier: CGFloat?
    public private(set) var rangeModifier: CGFloat?
    public private(set) var shotSpeedModifier: CGFloat?
    public private(set) var sizeModifier: CGFloat?
    public private(set) var turnRateModifier: CGFloat?
    public private(set) var fireRateModifier: CGFloat?
    public private(set) var itemRadiusModifier: CGFloat?
    
    // healing/money modifiers
    public private(set) var repairProportionally: Bool = false // if true, the repair value represents a proportion of health instead of a flat value
    public private(set) var repair: CGFloat?    // on pickup, gain this much health
    public private(set) var doubloons: Int?     // on pickup, gain this many doubloons
    
    // other modifiers
    public private(set) var cannonBallImage: String? = nil // replaces the current cannon ball image
    
    // raw values initialization
    init(name: String, imageName: String, tier: WPTItemTier, multiplicity: Int?, value: Int, prevalence: Int) {
        self.name = name
        self.imageName = imageName
        self.tier = tier
        self.multiplicity = multiplicity
        self.value = value
        self.prevalence = prevalence
        self.description = nil
    }
    
    // initialize from a dictionary
    init(_ itemDict: [String:AnyObject]) {
        self.name = itemDict["name"] as! String
        self.imageName = itemDict["imageName"] as! String
        self.tier = WPTItemTier.init(rawValue: itemDict["tier"] as! String)!
        self.multiplicity = itemDict["multiplicity"] as? Int
        self.value = itemDict["value"] as! Int
        self.prevalence = itemDict["prevalence"] as! Int
        self.cannonBallImage = itemDict["cannonBallImage"] as? String
        self.description = itemDict["description"] as? String
    }
    
    // initialize as currency
    init(asCurrency itemDict: [String:AnyObject]) {
        self.name = itemDict["name"] as! String
        self.imageName = itemDict["imageName"] as! String
        self.tier = WPTItemTier.currency
        self.multiplicity = nil
        self.value = itemDict["value"] as! Int
        self.prevalence = itemDict["prevalence"] as! Int
        
        self.doubloons = self.value // same for currency
        self.description = nil
    }
    
    // initialize as a repair item
    init(asRepair itemDict: [String:AnyObject]) {
        self.name = itemDict["name"] as! String
        self.imageName = itemDict["imageName"] as! String
        self.tier = WPTItemTier.repair
        self.multiplicity = nil
        self.value = itemDict["value"] as! Int
        self.prevalence = itemDict["prevalence"] as! Int
        let repairVal = itemDict["repair"] as! CGFloat
        self.repair = repairVal
        let repProp = itemDict["repairProportionally"] as! Bool
        self.repairProportionally = repProp
        let desc = itemDict["description"] as! String
        self.description = desc
    }
    
    // initialize as a stat modifier
    init(asStatModifier itemDict: [String:AnyObject]) {
        self.name = itemDict["name"] as! String
        self.imageName = itemDict["imageName"] as! String
        self.tier = WPTItemTier.statModifier
        self.multiplicity = itemDict["multiplicity"] as? Int
        self.value = itemDict["value"] as! Int
        self.prevalence = itemDict["prevalence"] as! Int
        self.cannonBallImage = itemDict["cannonBallImage"] as? String
        let desc = itemDict["description"] as! String
        self.description = desc
        
        initStatModifiers(itemDict)
    }
    
    private func initStatModifiers(_ dict: [String:AnyObject]) {
        self.speedModifier = getStatModifier(from: dict, name: "speed")
        self.damageModifier = getStatModifier(from: dict, name: "damage")
        self.healthModifier = getStatModifier(from: dict, name: "health")
        self.rangeModifier = getStatModifier(from: dict, name: "range")
        self.shotSpeedModifier = getStatModifier(from: dict, name: "shotSpeed")
        self.sizeModifier = getStatModifier(from: dict, name: "size")
        self.turnRateModifier = getStatModifier(from: dict, name: "turnRate")
        self.fireRateModifier = getStatModifier(from: dict, name: "fireRate")
        self.itemRadiusModifier = getStatModifier(from: dict, name: "itemRadius")
        
        self.repair = dict["repair"] as? CGFloat
        self.doubloons = dict["doubloons"] as? Int
    }
    
    private func getStatModifier(from dict: [String:AnyObject], name: String) -> CGFloat? {
        if let modifiers = dict["modifiers"] as? [String:CGFloat] {
            return modifiers[name]
        } else { return nil; }
    }
}

enum WPTItemTier: String {
    case currency = "CURRENCY"
    case repair = "REPAIR"
    case statModifier = "STAT_MODIFIER"
    case other = "OTHER"
}
