//
//  WPTShip.swift
//  Waypoint
//
//  Created by Hilary Schulz on 1/26/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTShip {
    let imageName: String
    let shipName = ""
    var speedScale = 1.0
    var damageScale = 1.0   //cannonball damage
    var healthScale = 1.0
    var rangeScale = 1.0   //cannonball distance
    var shotSpeedScale = 1.0  //cannonball travel speed
    
    init(imageName: String) {
        self.imageName = imageName
        self.initStats()
    }
    
    func initStats(speedScale: Double = 1.0, damageScale: Double = 1.0, healthScale: Double = 1.0, rangeScale: Double = 1.0, shotSpeedScale: Double = 1.0) {
        self.speedScale = speedScale
        self.damageScale = damageScale
        self.healthScale = healthScale
        self.rangeScale = rangeScale
        self.shotSpeedScale = shotSpeedScale
    }
}
