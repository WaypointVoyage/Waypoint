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
    
    init(enemy: WPTEnemy, player: WPTLevelPlayerNode) {
        self.enemy = enemy
        self.player = player
        super.init(actor: enemy)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        super.update(currentTime, deltaTime)
    }
}
