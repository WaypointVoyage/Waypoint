//
//  WPTLevelActorNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelActorNode: SKNode {
    
    let actor: WPTActor
    var actorSize: CGFloat {
        return WPTValues.actorDefaultSize * CGFloat(self.actor.ship.sizeScale)
    }
    
    // child nodes
    let sprite: SKSpriteNode
    
    init(actor: WPTActor) {
        self.actor = actor
        self.sprite = SKSpriteNode(imageNamed: actor.ship.inGameImage)
        super.init()
        
        self.zPosition = WPTValues.actorZPosition
        
        self.sprite.size = CGSize(width: self.actorSize, height: self.actorSize)
        self.addChild(self.sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
