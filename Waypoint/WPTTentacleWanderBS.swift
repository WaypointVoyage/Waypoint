//
//  WPTTentacleWanderBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 11/1/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTentacleWanderBS: WPTLollygaggingBS {
    
    private var target: CGPoint? = nil
    
    init() {
        let name = String(describing: WPTTentacleWave.self)
        super.init(name: name, objectiveTimeout: 1)
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
        
        let dir = CGVector(start: enemy.position, end: self.target!).normalized()
        let force = self.enemy.getShipSpeed() * dir
        
        self.enemy.physicsBody?.applyForce(force)
    }
    
}
