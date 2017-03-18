//
//  WPTCannonBallNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTCannonBallNode: SKNode {
    private let cannonBall: WPTCannonBall
    let sprite: SKSpriteNode
    
    let physics: SKPhysicsBody!
    
    init(_ cannonBall: WPTCannonBall) {
        self.cannonBall = cannonBall
        self.physics = SKPhysicsBody(circleOfRadius: 16)
        self.sprite = SKSpriteNode(imageNamed: cannonBall.image)
        super.init()
        
        sprite.scale(to: CGSize(width: 32, height: 32))
        self.addChild(sprite)
        
        self.physicsBody = physics
        physics.allowsRotation = false
        physics.angularDamping = 0
        physics.linearDamping = 0
        physics.friction = 0
        physics.categoryBitMask = WPTValues.projectileCbm
        physics.collisionBitMask = WPTValues.actorCbm | WPTValues.boulderCbm
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
