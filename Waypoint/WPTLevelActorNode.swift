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
    let physics: SKPhysicsBody!
    
    // movement
    var forward: CGVector { return CGVector(dx: cos(zRotation), dy: sin(zRotation)) }
    var targetRot: CGFloat? = nil
    var anchored: Bool = true
    
    // child nodes
    let sprite: SKSpriteNode
    var cannonNodes = [WPTCannonNode]()
    
    private let fireRateMgr: WPTFireRateManager
    
    init(actor: WPTActor) {
        self.actor = actor
        self.sprite = SKSpriteNode(imageNamed: actor.ship.inGameImage)
        self.physics = SKPhysicsBody(texture: self.sprite.texture!, size: self.sprite.frame.size)
        self.fireRateMgr = WPTFireRateManager(actor.ship)
        super.init()
        
        // sprite
        self.zPosition = WPTValues.actorZPosition
        self.addChild(self.sprite)
        
        // cannons
        for cannon in self.actor.ship.cannonSet.cannons {
            if cannon.hasCannon {
                let cannonNode = WPTCannonNode(cannon)
                self.cannonNodes.append(cannonNode)
                self.addChild(cannonNode)
            }
        }
        
        // configure physics behavior
        self.physicsBody = physics
        self.physics.allowsRotation = false
        self.physics.mass = WPTValues.actorMass
        self.physics.linearDamping = WPTValues.waterLinearDampening
        self.physics.angularDamping = WPTValues.waterAngularDampening
        self.physics.categoryBitMask = WPTValues.actorCbm
        self.physics.collisionBitMask = WPTValues.terrainCbm | WPTValues.boundaryCbm | WPTValues.boulderCbm
        
        // set starting position in the world
        self.zRotation += CGFloat(M_PI) / 2.0
        self.setScale(actor.ship.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        fireRateMgr.update(currentTime, deltaTime)
        
        // rotate to face target
        var turnVector: CGVector? = nil
        if let target = self.targetRot {
            turnVector = CGVector(dx: cos(target), dy: sin(target)) // unit vector pointing at target
            
            // calculate the angle delta
            let zRot = self.zRotation < 0 ? self.zRotation + 2.0 * CG_PI : self.zRotation   // target and zRot are in [0, 2pi)
            let delta1 = target - zRot                                                      // radians to turn one direction
            let delta2 = delta1 + (delta1 < 0 ? 2.0 : -2.0) * CG_PI                         // radians to turn the other direction
            let delta = abs(delta1) < abs(delta2) ? delta1 : delta2                         // use the smallest angle
            
            // apply the rotation
            let rate = CGFloat(deltaTime) * actor.ship.turnRate
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
                let speed: CGFloat = dot < 0 ? 0 : dot * actor.ship.speed
                force = speed * turnVector
            } else {
                force = actor.ship.speed * self.forward
            }
            self.physics.applyForce(force!)
        }
    }
    
    func fireCannons() {
        // make sure we can handle the cannon balls
        guard fireRateMgr.canFire else { return }
        guard let projectileNode = (self.scene as? WPTLevelScene)?.projectiles else { return }
        
        // create the cannon balls
        let time = actor.ship.range / actor.ship.shotSpeed
        for cannonNode in self.cannonNodes {
            let ball = WPTCannonBallNode(self.actor.cannonBall)
            ball.position = self.convert(cannonNode.cannonBallSpawnPoint, to: projectileNode)
            let direction = CGVector(dx: cos(self.zRotation + cannonNode.zRotation), dy: sin(self.zRotation + cannonNode.zRotation))
            ball.physics.velocity = actor.ship.shotSpeed * direction
            projectileNode.addChild(ball)
            ball.run(SKAction.wait(forDuration: Double(time)), completion: { ball.removeFromParent() })
        }
        fireRateMgr.registerFire()
    }
    
    func facePoint(_ target: CGPoint) {
        self.targetRot = CGVector(start: self.position, end: target).angle()
    }
}
