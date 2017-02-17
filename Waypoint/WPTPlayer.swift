//
//  WPTPlayer.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTPlayer: WPTActor {
    let shipName: String
    let progress: WPTPlayerProgress
    
    init(ship: WPTShip, shipName: String, _ progress: WPTPlayerProgress? = nil) {
        self.shipName = shipName
        self.progress = progress == nil ? WPTPlayerProgress(completedLevels: nil) : progress!
        super.init(ship: ship)
    }
}
