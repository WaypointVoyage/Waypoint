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
    var currentHealth: CGFloat
    var teamBitMask: UInt32
    
    // movement
    var forward: CGVector { return CGVector(dx: cos(zRotation), dy: sin(zRotation)) }
    var targetRot: CGFloat? = nil
    var anchored: Bool = true
    
    // child nodes
    let sprite: SKSpriteNode
    var cannonNodes = [WPTCannonNode]()
    
    let fireRateMgr: WPTFireRateManager
    
    public var isPlayer: Bool {
        return self as? WPTLevelPlayerNode != nil;
    }
    
    init(actor: WPTActor, teamBitMask tbm: UInt32) {
        self.actor = actor
        self.currentHealth = actor.ship.health
        self.sprite = SKSpriteNode(imageNamed: actor.ship.inGameImage)
        self.physics = SKPhysicsBody(texture: self.sprite.texture!, size: self.sprite.frame.size)
        self.fireRateMgr = WPTFireRateManager(actor.ship)
        self.teamBitMask = tbm
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
        self.physics.collisionBitMask = WPTValues.actorCbm | WPTValues.terrainCbm | WPTValues.boulderCbm
        
        // set starting position in the world
        self.zRotation += CGFloat(M_PI) / 2.0
        self.setScale(actor.ship.size)
        
        // components
        self.addChild(WPTWhirlpoolHandler(self))
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
    
    func distance(to actor: WPTLevelActorNode) -> CGFloat {
        let deltaX = actor.position.x - self.position.x
        let deltaY = actor.position.y - self.position.y
        return CGFloat(sqrt(deltaX * deltaX + deltaY * deltaY))
    }
    
    func getCannonVelocity(_ cannonNode: WPTCannonNode) -> CGVector {
        let rot = self.zRotation + cannonNode.zRotation
        let direction = CGVector(dx: cos(rot), dy: sin(rot))
        return actor.ship.shotSpeed * direction
    }
    
    func fireCannons() {
        // make sure we can handle the cannon balls
        guard fireRateMgr.canFire else { return }
        guard let projectileNode = (self.scene as? WPTLevelScene)?.projectiles else { return }
        
        // create the cannon balls
        let time = actor.ship.range / actor.ship.shotSpeed
        for cannonNode in self.cannonNodes {
            let ball = WPTCannonBallNode(self.actor.cannonBall, damage: self.actor.ship.damage)
            ball.teamBitMask = self.teamBitMask
            ball.position = self.convert(cannonNode.cannonBallSpawnPoint, to: projectileNode)
            ball.physics.velocity = getCannonVelocity(cannonNode)
            projectileNode.addChild(ball)
            ball.run(SKAction.wait(forDuration: Double(time)), completion: { ball.collideWithGround() })
            self.run(SKAction.playSoundFileNamed("cannon.mp3", waitForCompletion: false))
        }
        fireRateMgr.registerFire()
    }
    
    func facePoint(_ target: CGPoint) {
        self.targetRot = CGVector(start: self.position, end: target).angle()
    }
    
    func give(item: WPTItem) {
        // all items have the potential to give money
        if let doubloons = item.doubloons {
            actor.doubloons += doubloons
            if let top = (self.scene as? WPTLevelScene)?.hud.top {
                top.updateMoney()
            }
        }
        
        // could have a new cannon ball image?
        if let newImg = item.cannonBallImage {
            actor.cannonBall.image = newImg
        }
        
        // tier specific behavior
        switch (item.tier) {
        case WPTItemTier.statModifier:
            actor.apply(item: item)
        case WPTItemTier.other:
            if item.name == "Cannon" { addCannon() }
        default: break
        }
    }
    
    func doDamage(_ damage: CGFloat) {
        currentHealth += damage
    }
    
    private func addCannon() {
        for cannon in self.actor.ship.cannonSet.cannons {
            if !cannon.hasCannon {
                cannon.hasCannon = true
                let cannonNode = WPTCannonNode(cannon)
                self.cannonNodes.append(cannonNode)
                self.addChild(cannonNode)
                return
            }
        }
    }
}
