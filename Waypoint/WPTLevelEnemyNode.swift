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
    
    init(enemy: WPTEnemy, player: WPTLevelPlayerNode) {
        self.enemy = enemy
        self.player = player
        self.brain = WPTBrain(self.enemy.brainTemplate, player: self.player)
        super.init(actor: enemy)
        
        self.brain.enemy = self
        self.brain.start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        brain.update(deltaTime: deltaTime)
        super.update(currentTime, deltaTime)
    }
}
