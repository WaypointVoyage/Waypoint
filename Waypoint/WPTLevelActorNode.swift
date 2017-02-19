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
    
    let physics: SKPhysicsBody!
    
    // movement
    var forward: CGVector { return CGVector(dx: cos(zRotation), dy: sin(zRotation)) }
    var targetRot: CGFloat? = nil
    var boatSpeed: CGFloat = CGFloat(150)
    var anchored: Bool = true
    var turnRate: CGFloat { return CGFloat(self.actor.ship.turnRateScale) * 0.03 }
    
    // child nodes
    let sprite: SKSpriteNode
    
    init(actor: WPTActor) {
        self.actor = actor
        self.sprite = SKSpriteNode(imageNamed: actor.ship.inGameImage)
        self.physics = SKPhysicsBody(texture: self.sprite.texture!, size: self.sprite.frame.size)
        super.init()
        
        self.zPosition = WPTValues.actorZPosition
        self.addChild(self.sprite)
        self.physicsBody = physics
        self.physics.allowsRotation = false
        
        // set starting position in the world
        self.zRotation += 3.0 * CGFloat(M_PI) / 2.0
        self.setScale(self.actorSizeScale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        // TODO: use deltaTime to calculate rotation amount
        
        // rotate to face target
        if let target = self.targetRot {
            
            // calculate the angle delta
            let zRot = self.zRotation < 0 ? self.zRotation + 2.0 * CG_PI : self.zRotation // target and zRot are in [0, 2pi)
            let delta1 = target - zRot
            let delta2 = delta1 + (delta1 < 0 ? 1 : -1) * 2.0 * CG_PI
            let delta = abs(delta1) < abs(delta2) ? delta1 : delta2
            
            print("delta: \(delta)")
            
            // apply the rotation
            if abs(delta) < self.turnRate + 0.005 {
                self.zRotation = target
                self.targetRot = nil
            } else {
                self.zRotation += (delta > 0 ? 1 : -1) * self.turnRate
            }
        }
        
        // move foreward if not anchored
        self.physics.velocity = self.anchored ? CGVector.zero : self.boatSpeed * self.forward // TODO: switch to a force instead of altering velocity directly?
    }
    
    func facePoint(_ target: CGPoint) {
        self.targetRot = CGVector(start: self.position, end: target).angle()
        print("zRotation: \(self.zRotation)")
        print("target   : \(self.targetRot!)")
        print("delta    : \(self.targetRot! - self.zRotation)")
    }
}
