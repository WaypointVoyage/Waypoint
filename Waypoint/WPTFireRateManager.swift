//
//  WPTFireRateManager.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/20/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTFireRateManager: WPTUpdatable {
    
    private let ship: WPTShip
    private var lastFireTime: TimeInterval? = nil
    private var currentTime: TimeInterval? = nil
    
    var canFire: Bool {
        get {
            guard let curT = currentTime else { return false }
            guard let lastT = lastFireTime else { return true }
            return (curT - lastT) > (1.0 / Double(ship.fireRate))
        }
    }
    
    init(_ ship: WPTShip) {
        self.ship = ship
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        self.currentTime = currentTime
    }
    
    func registerFire() {
        self.lastFireTime = self.currentTime
    }
}
