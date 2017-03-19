//
//  WPTShipCatalog.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTShipCatalog {
    static let allShips: [WPTShip] = {
        var ships = [WPTShip]();
        
        for shipSet in [("the_ships", true), ("the_enemy_ships", false)] {
            let path = Bundle.main.path(forResource: shipSet.0, ofType: "plist")!
            for ship in NSArray(contentsOfFile: path) as! [[String:AnyObject]] {
                let testShip: Bool = (ship["testing"] as? Bool) ?? false
                if WPTConfig.values.testing || !testShip {
                    ships.append(WPTShip(dict: ship, playable: shipSet.1))
                }
            }
        }
        
        return ships;
    }()
    
    static let playableShips: [WPTShip] = WPTShipCatalog.allShips.filter() { $0.playable }
    static let shipsByName: [String:WPTShip] = {
        var map = [String:WPTShip]();
        for ship in WPTShipCatalog.allShips {
            map[ship.name] = ship;
        }
        return map;
    }()
}
