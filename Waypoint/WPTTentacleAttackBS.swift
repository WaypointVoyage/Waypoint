//
//  WPTTentacleAttackBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 11/1/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTTentacleAttackBS: WPTBrainState {
    static let type: WPTBrainStateType = WPTBrainStateType.OFFENSE
    
    private var direction: CGVector? = nil
    
    init() {
        super.init(name: String(describing: WPTTentacleAttackBS.self), type: WPTTentacleAttackBS.type)
    }
    
    override func didEnter(from previousState: GKState?) {
        self.direction = CGVector(start: self.enemy.position, end: self.player.position).normalized()
    }
    
    override func update(deltaTime seconds: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {
        self.update(deltaTime: seconds)
        
        let force = self.enemy.getShipSpeed() * 1.5 * self.direction!
        self.enemy.physicsBody?.applyForce(force)
    }
}
