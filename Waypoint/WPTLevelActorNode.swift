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
    var currentHealth: CGFloat
    var teamBitMask: UInt32
    let cannonEffect = WPTAudioNode(effect: "cannon", maxSounds: 20)
    let pearlDropEffect = WPTAudioNode(effect: "pearl_drop", maxSounds: 4)
    let gemDropEffect = WPTAudioNode(effect: "gem_drop", maxSounds: 4)
    let coinDropEffect = WPTAudioNode(effect: "coin_drop", maxSounds: 4)
    let itemEffect = WPTAudioNode(effect: "item_collection")
    let anchorDownEffect = WPTAudioNode(effect: "anchor_down")
    let anchorUpEffect = WPTAudioNode(effect: "anchor_up")
    
    // movement
    private var facingZRotation: CGFloat = 0
    var forward: CGVector {
        let zRot = self.actor.ship.turnWhenFacing ? zRotation : facingZRotation
        return CGVector(dx: cos(zRot), dy: sin(zRot))
    }
    var targetRot: CGFloat? = nil
    var anchored: Bool = true
    var targetNode: SKNode? = nil
    var portSide: CGVector {
        let forward = self.forward
        return CGVector(dx: -forward.dy, dy: forward.dx) // TODO: verify
    }
    var starboardSide: CGVector {
        let forward = self.forward
        return CGVector(dx: forward.dy, dy: -forward.dx) // TODO: verify
    }
    
    var spriteImage: String {
        return self.actor.ship.inGameImage
    }
    
    // child nodes
    var sprite: SKSpriteNode! = nil
    var cannonNodes = [WPTCannonNode]()
    
    // death watchers
    public private(set) var deathObservers: [() -> Void] = [() -> Void]()
    
    let fireRateMgr: WPTFireRateManager
    
    public var isPlayer: Bool {
        return self as? WPTLevelPlayerNode != nil;
    }
    
    public var hasAllCannons: Bool {
        return !self.actor.ship.cannonSet.cannons.contains(where: {
            return !$0.hasCannon
        })
    }
    
    init(actor: WPTActor, teamBitMask tbm: UInt32) {
        self.actor = actor
        self.currentHealth = actor.ship.health
        self.fireRateMgr = WPTFireRateManager(actor.ship)
        self.teamBitMask = tbm
        super.init()
        self.physicsBody = SKPhysicsBody(polygonFrom: actor.ship.colliderPath)
        self.zPosition = WPTZPositions.actors - WPTZPositions.terrain
        
        // sprite
        self.sprite = SKSpriteNode(imageNamed: self.spriteImage)
        self.sprite.position = self.actor.ship.imageOffset
        self.addChild(self.sprite)
        
        // cannons
        for cannon in self.actor.ship.cannonSet.cannons {
            if cannon.hasCannon {
                let cannonNode = WPTCannonNode(cannon, actor: self)
                self.cannonNodes.append(cannonNode)
                self.addChild(cannonNode)
            }
        }
        self.addChild(cannonEffect)
        self.addChild(itemEffect)
        self.addChild(pearlDropEffect)
        self.addChild(gemDropEffect)
        self.addChild(coinDropEffect)
        self.addChild(anchorUpEffect)
        self.addChild(anchorDownEffect)
        
        // configure physics behavior
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.mass = WPTValues.actorBaseMass * actor.ship.sizeScale
        self.physicsBody!.linearDamping = WPTValues.waterLinearDampening
        self.physicsBody!.angularDamping = WPTValues.waterAngularDampening
        self.physicsBody!.categoryBitMask = WPTValues.actorCbm
        self.physicsBody!.collisionBitMask = WPTValues.actorCbm | WPTValues.terrainCbm | WPTValues.boulderCbm
        self.physicsBody!.contactTestBitMask = WPTValues.damageActorCbm
        
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
            applyRotation(target: target, delta: delta, rate: rate)
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
            self.physicsBody?.applyForce(force!)
        }
    }
    
    private func applyRotation(target: CGFloat, delta: CGFloat, rate: CGFloat) {
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
        cannonEffect.playEffect()
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
    
    func faceDirection(_ angle: CGFloat) {
        let target = self.position + CGVector(radians: angle)
        self.facePoint(target)
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
            itemEffect.playEffect()
            let healthBefore = self.actor.ship.health
            actor.apply(item: item)
            let healthAfter = self.actor.ship.health
            let healthChange = healthAfter - healthBefore
            // if the item increased health, we want them to gain the extra health
            if healthChange != 0 {
                self.doDamage(healthChange)
            }
        case WPTItemTier.currency:
            if item.name.contains("Coin") {
                coinDropEffect.playEffect()
            } else if item.name.contains("Pearls") {
                pearlDropEffect.playEffect()
            } else {
                gemDropEffect.playEffect()
            }
        case WPTItemTier.repair:
            itemEffect.playEffect()
        case WPTItemTier.other:
            if item.name == "Cannon" {
                cannonEffect.playEffect()
                addCannon()
            }
        }
    }
    
    func doDamage(_ damage: CGFloat) {
        currentHealth += damage
        currentHealth = currentHealth > actor.ship.health ? actor.ship.health : currentHealth // clamp
    }
    
    private func addCannon() {
        if let cannon = self.actor.addCannon() {
            let cannonNode = WPTCannonNode(cannon, actor: self)
            self.cannonNodes.append(cannonNode)
            self.addChild(cannonNode)
        }
    }
    
    public func onDeath(_ action: @escaping () -> Void) {
        self.deathObservers.append(action)
    }
}
