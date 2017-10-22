//
//  WPTFaceRandomDirectionsBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/21/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTFaceRandomDirectionsBS: WPTLollygaggingBS {
    
    private var angle: CGFloat? = nil
    
    init() {
        let name = String(describing: WPTFaceRandomDirectionsBS.self)
        super.init(name: name)
    }
    
    override func needNewObjective() -> Bool {
        return self.angle == nil
    }
    
    override func setObjective() {
        self.angle = randomNumber(min: 0, max: 2 * CG_PI)
    }
    
    override func removeObjective() {
        self.angle = nil
    }
    
    override func objectiveSatisfied() -> Bool {
        let diff = abs(zRotationToRadians(self.enemy.zRotation) - self.angle!)
        return diff < 0.1
    }
    
    override func updateWithObjective(deltaTime sec: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {
        self.enemy.faceDirection(self.angle!)
    }
}
