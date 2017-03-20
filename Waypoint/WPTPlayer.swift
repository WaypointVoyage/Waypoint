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
    
    // save data
    var health: CGFloat? = nil
    var completedLevels: [String]
    
    init(ship: WPTShip, shipName: String, completedLevels: [String]? = nil) {
        self.shipName = shipName
        self.completedLevels = completedLevels ?? [String]()
        super.init(ship: ship)
    }
}
