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
    var teamBitMask: UInt32? = nil
    let damage: CGFloat
    
    init(_ cannonBall: WPTCannonBall, damage: CGFloat, size: CGFloat) {
        let baseSize: CGFloat = 45
        self.damage = damage
        self.cannonBall = cannonBall
        self.physics = SKPhysicsBody(circleOfRadius: baseSize * size)
        self.sprite = SKSpriteNode(imageNamed: cannonBall.image)
        super.init()

        sprite.scale(to: CGSize(width: 2 * baseSize * size, height: 2 * baseSize * size))
        self.addChild(sprite)
        
        self.physicsBody = physics
        physics.allowsRotation = false
        physics.angularDamping = 0
        physics.linearDamping = 0
        physics.friction = 0
        physics.categoryBitMask = WPTValues.projectileCbm
        physics.collisionBitMask = WPTValues.boulderCbm
        physics.contactTestBitMask = WPTValues.actorCbm | WPTValues.damageActorCbm
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collide(with actor: WPTLevelActorNode) {
        
        var damage = (self.damage / WPTShip.baseDamage) - (actor.actor.ship.size - 1.0)
        damage = WPTShip.baseDamage * damage
        actor.doDamage(-damage)
        
        // TODO: apply damage/update health bars/explosion?
        
        self.removeFromParent()
    }
    
    func collideWithGround() {
        
        // TODO: splash/dusk cloud?
        
        
        self.removeFromParent()
    }
}
