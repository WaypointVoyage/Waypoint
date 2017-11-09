//
//  WPTPlayer.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/3/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTActor {
    var ship: WPTShip;
    let cannonBall: WPTCannonBall = WPTCannonBall()
    
    // currency
    var doubloons: Int = 0 {
        didSet {
            if self.doubloons < 0 {
                self.doubloons = 0
            }
        }
    }
    
    // items
    var items: [WPTItem] = [] // items that modify behavior
    private var itemCounts: [String:Int] = [:] // item.name -> count
    
    init(ship: WPTShip) {
        self.ship = ship
    }
    
    func apply(item: WPTItem) {
        guard item.tier == .statModifier else {
            if item.name == "Cannon" {
                let _ = self.addCannon()
            }
            return
        }
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
            ship.upgrade(with: item)
        }
    }
    
    func addCannon() -> WPTCannon? {
        var positions = [Int]()
        for i in 0..<self.ship.cannonSet.cannons.count {
            let cannon = self.ship.cannonSet.cannons[i]
            if !cannon.hasCannon {
                positions.append(i)
            }
        }
        if positions.isEmpty {
            return nil
        }
        
        let rand = Int(randomNumber(min: 0, max: CGFloat(positions.count)))
        let cannon = self.ship.cannonSet.cannons[positions[rand]]
        cannon.hasCannon = true
        return cannon
    }
}
