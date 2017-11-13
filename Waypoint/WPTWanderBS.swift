//
//  WPTWanderBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/18/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTWanderBS: WPTLollygaggingBS {
    
    private var target: CGPoint? = nil
    
    init() {
        let name = String(describing: WPTWanderBS.self)
        super.init(name: name)
    }
    
    init(name: String) {
        super.init(name: name)
    }
    
    override func needNewObjective() -> Bool {
        return self.target == nil
    }
    
    override func setObjective() {
        let terrain = (enemy.scene as! WPTLevelScene).terrain
        self.target = terrain.randomPoint(borderWidth: 0, onLand: false)
    }
    
    override func removeObjective() {
        self.target = nil
    }
    
    override func objectiveSatisfied() -> Bool {
        let dist = CGVector(start: enemy.position, end: self.target!).magnitude()
        return dist < brain.radiusOfEngagement
    }
    
    override func updateWithObjective(deltaTime sec: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {
        self.enemy.anchored = false
        self.enemy.facePoint(self.target!)
    }
}
