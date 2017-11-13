//
//  WPTLevelTentacleNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/20/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelTentacleNode: WPTLevelEnemyNode {
    private let tentacleEnemy: WPTEnemy
    private var cropNode: SKCropNode! = nil
    
    public let isStatic: Bool
    private let type: WPTTentacleEnemyType
    public private(set) var isSubmerged: Bool = false
    
    private let bubbles: WPTBubbleSurfaceNode
    
    private var surfaceSpritePos: CGPoint! = nil
    private var submergedSpritePos: CGPoint! = nil
    
    private var holdPhysics: SKPhysicsBody? = nil
    private var physicsChild: SKNode? = nil
    
    private var invincible: Bool = false
    
    init(type: WPTTentacleEnemyType, player: WPTLevelPlayerNode, submerged: Bool) {
        var cropSprite: String = "tentacle_crop"
        self.type = type
        switch (type) {
        case .STATIC_TENTACLE:
            self.isStatic = true
            self.tentacleEnemy = WPTEnemyCatalog.enemiesByName["Static Tentacle"]!
            self.bubbles = WPTBubbleSquareSurfaceNode(width: 100, height: 100, amount: 3, time: 0.6)
        case .DYNAMIC_TENTACLE:
            self.isStatic = false
            self.tentacleEnemy = WPTEnemyCatalog.enemiesByName["Dynamic Tentacle"]!
            self.bubbles = WPTBubbleSquareSurfaceNode(width: 100, height: 100, amount: 3, time: 0.6)
        case .KRAKEN_HEAD:
            self.isStatic = true
            self.tentacleEnemy = WPTEnemyCatalog.enemiesByName["Kraken"]!
            self.bubbles = WPTBubbleSquareSurfaceNode(width: 150, height: 500, amount: 30, time: 0.6)
            cropSprite = "kraken_crop"
        }
        
        super.init(enemy: self.tentacleEnemy, player: player)
        self.zPosition = player.zPosition + 2
        
        self.dropCoins = false // the kraken shouldn't drop coins
        self.explodes = false // it also shouldn't explode
        
        // physics
        self.physicsBody!.isDynamic = !isStatic
        self.physicsBody!.categoryBitMask = WPTValues.damageActorCbm
        self.holdPhysics = self.physicsBody
        self.physicsBody = nil
        
        // sprite
        self.cropNode = SKCropNode()
        self.cropNode.maskNode = SKSpriteNode(imageNamed: cropSprite)
        self.cropNode.position = self.sprite.position
        self.addChild(cropNode)
        self.sprite.removeFromParent()
        self.cropNode.addChild(self.sprite)
        self.surfaceSpritePos = CGPoint.zero
        self.submergedSpritePos = self.surfaceSpritePos - CGVector(dx: self.sprite.size.width, dy: 0)
        self.sprite.position = self.submergedSpritePos
        
        // bubbles
        self.bubbles.setScale(1 / self.actor.ship.size)
        self.bubbles.zPosition = -1
        self.addChild(bubbles)
        self.bubbles.start()
        
        // submerge
        self.isSubmerged = !submerged
        if submerged {
            self.submerge(duration: 0.0)
        }
        self.isSubmerged = submerged
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBubbles(_ value: Bool) {
        if value && self.bubbles.stopped {
            self.bubbles.start()
        } else if !value && !self.bubbles.stopped {
            self.bubbles.stop()
        }
    }
    
    func setPosition(_ position: CGPoint) {
        self.position = position
    }
    
    func handlePhysicsForSubmerge() {
        if (self.isStatic) {
            self.physicsChild?.removeFromParent()
            self.physicsChild = nil
        }
        
        else {
            self.physicsBody = nil
        }
    }
    
    func submerge(duration: TimeInterval = 1.0, then: (() -> Void)? = nil) {
        guard !self.isSubmerged else { return }
        
        self.invincible = true
        self.handlePhysicsForSubmerge()
        
        self.sprite.run(SKAction.move(to: self.submergedSpritePos, duration: duration)) {
            self.isSubmerged = true
            if let then = then {
                then()
            }
        }
    }
    
    func handlePhysicsForSurface() {
        if self.isStatic {
            self.physicsChild = SKNode()
            self.physicsChild?.physicsBody = self.holdPhysics!
            self.addChild(self.physicsChild!)
        }
        
        else {
            self.physicsBody = self.holdPhysics
        }
    }
    
    func surface(duration: TimeInterval = 0.4, then: (() -> Void)? = nil) {
        guard self.isSubmerged else { return }
        
        self.handlePhysicsForSurface()
        
        self.sprite.run(SKAction.move(to: self.surfaceSpritePos, duration: duration)) {
            self.isSubmerged = false
            self.invincible = false
            if let then = then {
                then()
            }
        }
    }
    
    override func doDamage(_ damage: CGFloat) {
        guard !self.invincible else { return }
        
        super.doDamage(damage)
        if self.healthBar.curHealth <= 0 {
            self.destroyEnemy()
        }
    }
    
    override func destroyEnemy() {
        super.destroyEnemy()
        
        // remove physics
        self.physicsChild?.removeFromParent()
        self.physicsChild = nil
        
        // submerge
        if !self.isSubmerged {
            self.submerge(duration: WPTLevelEnemyNode.DEATH_DELAY)
        }
    }
}

enum WPTTentacleEnemyType {
    case STATIC_TENTACLE
    case DYNAMIC_TENTACLE
    case KRAKEN_HEAD
}
