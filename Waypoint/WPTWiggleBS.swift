//
//  WPTWiggleBS.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTWiggleBS: WPTBrainState {
    static let type: WPTBrainStateType = WPTBrainStateType.NOTHING
    var rootPosition: CGPoint? = nil
    let wiggleWidth: CGFloat = 1.0
    let wiggleHeight: CGFloat = 2.0
    var wiggleTime: TimeInterval = 0.0
    let wiggleScale: CGFloat = 1.0
    
    init() {
        super.init(name: String(describing: WPTWiggleBS.self), type: WPTWiggleBS.type)
    }
    
    override func didEnter(from previousState: GKState?) {
        self.rootPosition = enemy.position
        self.wiggleTime = 0.0
    }
    
    override func update(deltaTime sec: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {
        self.update(deltaTime: sec)
        enemy.anchored = true
        enemy.targetRot = nil
        enemy.position = self.rootPosition! + self.wiggle(deltaTime:sec)
    }
    
    func wiggle(deltaTime: TimeInterval) -> CGPoint {
        guard (self.rootPosition != nil) else {
            return self.enemy.position
        }
        self.wiggleTime += deltaTime
        return CGPoint(x: wiggleWidth * sin(wiggleScale * CGFloat(wiggleTime)),
                       y: wiggleHeight * sin(wiggleScale * CGFloat(wiggleTime)))
    }
    
}
