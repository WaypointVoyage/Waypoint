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
    var boatSpeed: CGFloat { return CGFloat(self.actor.ship.speedScale) * 3500.0 }
    var anchored: Bool = true
    var turnRate: CGFloat { return CGFloat(self.actor.ship.turnRateScale) }
    
    // child nodes
    let sprite: SKSpriteNode
    
    init(actor: WPTActor) {
        self.actor = actor
        self.sprite = SKSpriteNode(imageNamed: actor.ship.inGameImage)
        self.physics = SKPhysicsBody(texture: self.sprite.texture!, size: self.sprite.frame.size)
        super.init()
        
        self.zPosition = WPTValues.actorZPosition
        self.addChild(self.sprite)
        
        // configure physics behavior
        self.physicsBody = physics
        self.physics.allowsRotation = false
        self.physics.mass = WPTValues.actorMass
        self.physics.linearDamping = WPTValues.waterLinearDampening
        self.physics.angularDamping = WPTValues.waterAngularDampening        
        
        // set starting position in the world
        self.zRotation += 3.0 * CGFloat(M_PI) / 2.0
        self.setScale(self.actorSizeScale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        var turnVector: CGVector? = nil
        
        // rotate to face target
        if let target = self.targetRot {
            turnVector = CGVector(dx: cos(target), dy: sin(target))
            
            // calculate the angle delta
            let zRot = self.zRotation < 0 ? self.zRotation + 2.0 * CG_PI : self.zRotation   // target and zRot are in [0, 2pi)
            let delta1 = target - zRot                                                      // radians to turn one direction
            let delta2 = delta1 + (delta1 < 0 ? 2.0 : -2.0) * CG_PI                         // radians to turn the other direction
            let delta = abs(delta1) < abs(delta2) ? delta1 : delta2                         // use the smallest angle
            
            // apply the rotation
            let rate = self.turnRate * CGFloat(deltaTime)
            if abs(delta) < rate + 0.005 {
                self.zRotation = target
                self.targetRot = nil
            } else {
                self.zRotation += (delta > 0 ? 1 : -1) * rate
            }
        }
        
        // move foreward if not anchored
        if !self.anchored {
            var force: CGVector? = nil
            if let turnVector = turnVector {
                let dot = forward.dot(turnVector)
                let speed: CGFloat = dot < 0 ? 0 : dot * boatSpeed
                force = speed * turnVector
            } else {
                force = self.boatSpeed * self.forward
            }
            self.physics.applyForce(force!)
        }
    }
    
    func facePoint(_ target: CGPoint) {
        self.targetRot = CGVector(start: self.position, end: target).angle()
    }
}
