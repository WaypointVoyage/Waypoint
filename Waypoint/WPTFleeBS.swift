//
//  WPTFleeBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/11/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTFleeBS: WPTBrainState {
    static let type: WPTBrainStateType = WPTBrainStateType.FLEE
    
    init() {
        super.init(name: String(describing: WPTFleeBS.self), type: WPTFleeBS.type)
    }
    
    override func update(deltaTime sec: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {
        self.update(deltaTime: sec)
        enemy.anchored = false
        let towardsPlayer = CGVector(dx: player.position.x - enemy.position.x, dy: player.position.y - enemy.position.y)
        let target = CGPoint(x: enemy.position.x - towardsPlayer.dx, y: enemy.position.y - towardsPlayer.dy)
        enemy.facePoint(target)
    }
}
