//
//  WPTLevelActorNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelActorNode: SKNode, WPTUpdatable {
    
    let actor: WPTActor
    var actorSizeScale: CGFloat {
        return WPTValues.actorDefaultSizeScale * CGFloat(self.actor.ship.sizeScale)
    }
    
    var forward: Vec2 = Vec2(x: 0, y: 1)
    var boatSpeed: CGFloat = CGFloat(5)
    
    // child nodes
    let sprite: SKSpriteNode
    
    init(actor: WPTActor) {
        self.actor = actor
        self.sprite = SKSpriteNode(imageNamed: actor.ship.inGameImage)
        super.init()
        
        self.zPosition = WPTValues.actorZPosition
        
        self.setScale(self.actorSizeScale)
        self.addChild(self.sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval) {
        
    }
}
