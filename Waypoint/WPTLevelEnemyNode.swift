//
//  WPTLevelEnemyNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelEnemyNode: WPTLevelActorNode {
    let enemy: WPTEnemy
    let player: WPTLevelPlayerNode
    
    let brain: WPTBrain
    var brainRadii: WPTBrainRadiiNode? = nil
    
    init(enemy: WPTEnemy, player: WPTLevelPlayerNode) {
        self.enemy = enemy
        self.player = player
        self.brain = WPTBrain(self.enemy.brainTemplate, player: self.player)
        super.init(actor: enemy)
        
        self.brain.enemy = self
        self.brain.setBehavior()
        self.brain.start()
        if WPTConfig.values.showBrainRadii {
            self.brainRadii = WPTBrainRadiiNode(brain: self.brain)
            self.brainRadii?.setScale(1.0 / enemy.ship.size) // have to invert enemy scaling to get appropriate sizes
            self.addChild(brainRadii!);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        brain.update(deltaTime: deltaTime)
        if let brainRadii = self.brainRadii {
            brainRadii.update(currentTime, deltaTime)
        }
        super.update(currentTime, deltaTime)
    }
}
