//
//  WPTFireRateManager.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/20/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTFireRateManager: WPTUpdatable {
    
    private let ship: WPTShip
    private var lastFireTime: TimeInterval? = nil
    private var currentTime: TimeInterval? = nil
    
    private var enabled: Bool = true
    
    var modifier: CGFloat = 1
    
    var canFire: Bool {
        get {
            guard self.enabled else { return false }
            guard let curT = currentTime else { return false }
            guard let lastT = lastFireTime else { return true }
            return (curT - lastT) > (1.0 / Double(modifier * ship.fireRate))
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
    
    public func enable() {
        self.enabled = true
    }
    
    public func disable() {
        self.enabled = false
    }
}
