//
//  WPTPlayer.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/3/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTActor {
    // ship
    var shipName: String
    var ship: WPTShip
    
    // currency
    var doubloons: Int = 0 {
        didSet {
            if self.doubloons < 0 {
                self.doubloons = 0
            }
        }
    }
    
    // health
    static let minHealth = 0.0
    static let maxHealth = 100.0
    var health: Double = WPTActor.maxHealth {
        didSet {
            if self.health < WPTActor.minHealth {
                self.health = WPTActor.minHealth
            }
            else if self.health > WPTActor.maxHealth {
                self.health = WPTActor.maxHealth
            }
        }
    }
    
    // items
    var items: [WPTItem] = []
    var itemCounts: [String:Int] = [:] // item.name -> count
    
    init(shipName: String, ship: WPTShip) {
        self.shipName = shipName
        self.ship = ship
    }
    
    func apply(item: WPTItem) {
        var canAdd = true
        
        // update the item's count
        if let mult = item.multiplicity {
            if mult > 0 {
                if let curCount = itemCounts[item.name] {
                    if curCount >= mult {
                        canAdd = false
                    } else {
                        itemCounts[item.name] = curCount + 1
                    }
                } else {
                    itemCounts[item.name] = 1
                }
            }
        }
        
        // add it to the item array
        if canAdd {
            self.items.append(item)
        }
    }
}
