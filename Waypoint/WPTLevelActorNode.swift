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
    var physics: SKPhysicsBody?
    var currentHealth: CGFloat
    var teamBitMask: UInt32
    
    // movement
    private var facingZRotation: CGFloat = 0
    var forward: CGVector {
        let zRot = self.actor.ship.turnWhenFacing ? zRotation : facingZRotation
        return CGVector(dx: cos(zRot), dy: sin(zRot))
    }
    var targetRot: CGFloat? = nil
    var anchored: Bool = true
    var targetNode: SKNode? = nil
    
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
        self.physics = SKPhysicsBody(polygonFrom: actor.ship.colliderPath)
        self.fireRateMgr = WPTFireRateManager(actor.ship)
        self.teamBitMask = tbm
        super.init()
        
        // sprite
        self.zPosition = WPTZPositions.actors - WPTZPositions.terrain
        self.addChild(self.sprite)
        
        // cannons
        for cannon in self.actor.ship.cannonSet.cannons {
            if cannon.hasCannon {
                let cannonNode = WPTCannonNode(cannon, actor: self)
                self.cannonNodes.append(cannonNode)
                self.addChild(cannonNode)
            }
        }
        
        // configure physics behavior
        self.physicsBody = physics
        self.physics!.allowsRotation = false
        self.physics!.mass = WPTValues.actorBaseMass * actor.ship.sizeScale
        self.physics!.linearDamping = WPTValues.waterLinearDampening
        self.physics!.angularDamping = WPTValues.waterAngularDampening
        self.physics!.categoryBitMask = WPTValues.actorCbm
        self.physics!.collisionBitMask = WPTValues.actorCbm | WPTValues.terrainCbm | WPTValues.boulderCbm
        
        // set starting position in the world
        self.zRotation += CG_PI / 2.0
        self.facingZRotation = zRotation
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
            applyRotation(delta: delta, rate: rate)
        }
        
        // move foreward if not anchored
        if !self.anchored {
            var force: CGVector? = nil
            if let turnVector = turnVector {
                let dot = forward.dot(turnVector)
                let speed: CGFloat = dot < 0 ? 0 : dot * getShipSpeed()
                force = speed * turnVector
            } else {
                force = getShipSpeed() * self.forward
            }
            self.physics?.applyForce(force!)
        }
    }
    
    private func applyRotation(delta: CGFloat, rate: CGFloat) {
        if abs(delta) < rate + 0.005 {
            
            self.targetRot = nil
            
            if self.actor.ship.turnWhenFacing {
                self.zRotation = target
            } else {
                self.facingZRotation = target
            }
            
        } else {
            
            let deltaRot = (delta > 0 ? 1 : -1) * rate
            
            if self.actor.ship.turnWhenFacing {
                self.zRotation += deltaRot
            } else {
                self.facingZRotation += deltaRot
            }
            
        }
    }
    
    func getShipSpeed() -> CGFloat {
        return actor.ship.speed
    }
    
    func distance(to actor: WPTLevelActorNode) -> CGFloat {
        let deltaX = actor.position.x - self.position.x
        let deltaY = actor.position.y - self.position.y
        return CGFloat(sqrt(deltaX * deltaX + deltaY * deltaY))
    }
    
    func fireCannons() {
        // make sure we can handle the cannon balls
        guard fireRateMgr.canFire else { return }
        
        // create the cannon balls
        for cannonNode in self.cannonNodes {
            cannonNode.fire()
        }
        fireRateMgr.registerFire()
    }
    
    func aimAt(node target: SKNode) {
        self.targetNode = target
        self.targetRot = nil
    }
    
    func aimCannons(node target: SKNode) {
        let toTarget = CGVector(start: position, end: target.position)
        
        var closestCannon: WPTCannonNode? = nil
        var bestDot: CGFloat? = nil
        for cannon in cannonNodes {
            let angle = zRotation + cannon.zRotation
            let forward = CGVector(dx: cos(angle), dy: sin(angle))
            let dot = forward.dot(toTarget)
            if closestCannon == nil || dot > bestDot! {
                closestCannon = cannon
                bestDot = dot
            }
        }
        
        if let cannon = closestCannon {
            targetRot = toTarget.angle() - cannon.zRotation
        }
    }
    
    func facePoint(_ target: CGPoint) {
        self.targetRot = CGVector(start: self.position, end: target).angle()
        self.targetNode = nil
    }
    
    func give(item: WPTItem) {
        // all items have the potential to give money
        if let doubloons = item.doubloons {
            actor.doubloons += doubloons
        }
        
        // all items have the potential to do repairs
        if let repair = item.repair {
            if item.repairProportionally {
                self.currentHealth += repair * self.actor.ship.health
            } else {
                self.currentHealth += repair
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
        currentHealth = currentHealth > actor.ship.health ? actor.ship.health : currentHealth // clamp
    }
    
    private func addCannon() {
        for cannon in self.actor.ship.cannonSet.cannons {
            if !cannon.hasCannon {
                cannon.hasCannon = true
                let cannonNode = WPTCannonNode(cannon, actor: self)
                self.cannonNodes.append(cannonNode)
                self.addChild(cannonNode)
                return
            }
        }
    }
}
