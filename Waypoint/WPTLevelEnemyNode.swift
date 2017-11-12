//
//  WPTLevelEnemyNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelEnemyNode: WPTLevelActorNode {
    static let DEATH_DELAY: TimeInterval = 0.5
    
    let enemy: WPTEnemy
    let player: WPTLevelPlayerNode
    
    public private(set) var brain: WPTBrain?
    var brainRadii: WPTBrainRadiiNode? = nil
    let healthBar: WPTHealthNode
    let explosionEffect = WPTAudioNode(effect: "explosion", maxSounds: 1)
    
    var isDead: Bool = false
    var dropCoins: Bool = true
    var explodes: Bool = true
    
    init(enemy: WPTEnemy, player: WPTLevelPlayerNode, startBrain: Bool = false, health: CGFloat? = nil) {
        self.enemy = enemy
        self.player = player
        self.brain = WPTBrain(self.enemy.brainTemplate, player: self.player)
        let startHealth = health ?? enemy.ship.health
        self.healthBar = WPTHealthNode(maxHealth: enemy.ship.health, curHealth: startHealth, persistent: false)
        super.init(actor: enemy, teamBitMask: WPTValues.enemyTbm)
        
        // brain
        self.brain!.enemy = self
        self.brain!.setBehavior()
        if startBrain {
            self.brain!.start()
        }
        if WPTConfig.values.showBrainRadii {
            self.brainRadii = WPTBrainRadiiNode(brain: self.brain!)
            self.brainRadii?.setScale(1.0 / enemy.ship.size) // have to invert enemy scaling to get appropriate sizes
            self.addChild(brainRadii!);
        }
        
        healthBar.shipHealthBar.position = CGPoint(
            x: self.position.x,
            y: self.position.y - WPTValues.fontSizeMedium
        )
        healthBar.setScale(1 / enemy.ship.size)
        self.addChild(healthBar)
        
        self.addChild(explosionEffect)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        if brain != nil && brain!.started {
            brain!.update(deltaTime: deltaTime)
        } else {
            // until the brain is started, just move towards the player
            self.anchored = false
            self.facePoint(player.position)
        }
        if let brainRadii = self.brainRadii {
            brainRadii.update(currentTime, deltaTime)
        }
        
        super.update(currentTime, deltaTime)
        healthBar.zRotation = -self.zRotation
        
        // check to see if the brain should start
        if self.brain != nil && !self.brain!.started {
            if self.enemy.terrainType == .land {
                self.brain?.start()
            } else {
                // once the enemy is inside the boundary, they will collide with it
                if let phys = self.physicsBody {
                    if phys.collisionBitMask & WPTValues.boundaryCbm == 0 {
                        if let scene = self.scene as? WPTLevelScene {
                            let terrainBox = CGRect(origin: CGPoint.zero, size: scene.terrain.size)
                            let enemyBoxOrigin = CGPoint(x: self.position.x - self.sprite.frame.width / 5, y: self.position.y - self.sprite.frame.height / 5)
                            let enemyBox = CGRect(origin: enemyBoxOrigin, size: self.sprite.frame.size)
                            if terrainBox.contains(enemyBox) {
                                self.physicsBody?.collisionBitMask |= WPTValues.boundaryCbm
                                self.brain?.start()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateHealth() {
        self.healthBar.maxHealth = self.enemy.ship.health
    }
    
    override func doDamage(_ damage: CGFloat) {
        NSLog("doing \(damage) damage to a \(self.enemy.name)")
        super.doDamage(damage)
        let alive = healthBar.updateHealth(damage)
        if !alive && self.physicsBody != nil {
            destroyEnemy()
        }
    }
    
    func destroyEnemy() {
        self.physicsBody = nil // at this point on, there are is no more world interaction
        self.isDead = true
        self.brain = nil
        
        // explode
        let explosionNode = SKSpriteNode(imageNamed: "explode")
        if self.explodes {
            explosionNode.position = self.sprite.position
            explosionNode.size = CGSize(width: self.sprite.size.width, height: self.sprite.size.height)
            explosionNode.zPosition = self.sprite.zPosition + WPTValues.fontSizeSmall
            self.addChild(explosionNode)
        }
        
        self.explosionEffect.playEffect()
        self.run(SKAction.wait(forDuration: WPTLevelEnemyNode.DEATH_DELAY)) {
            if let scene = self.scene as? WPTLevelScene {
                if self.dropCoins {
                    scene.dropCoins(position: self.position, size: WPTBoulderNode.coinDropSize)
                }
                explosionNode.removeFromParent()
                if let scene = (self.scene as? WPTLevelScene) {
                    scene.terrain.removeEnemy(self)
                }
            } else {
                NSLog("Scene is nil...")
            }
        }
        
        // actions for observers
        for action in self.deathObservers {
            action()
        }
        
        // bubbles
        if let scene = self.scene as? WPTLevelScene {
            if !scene.terrain.pointOnLand(scenePoint: self.position) {
                let bubbles = WPTBubbleSquareSurfaceNode(width: 60, height: 60, amount: 3, time: 0.6)
                bubbles.position = self.position
                scene.terrain.addChild(bubbles)
                
                bubbles.start()
                bubbles.run(SKAction.wait(forDuration: 2.5)) {
                    bubbles.stop()
                    bubbles.removeFromParent()
                }
            }
        }
        
        // a bit of health?
        if self.enemy.dropHealth {
            let chance = randomNumber(min: 0, max: 1)
            if chance < 0.33 {
                let repair = WPTItemCatalog.itemsByName["Minor Ship Maintenance"]!
                let repairNode = WPTItemNode(repair, duration: 5.0)
                repairNode.position = self.position
                let itemNode = (self.scene as! WPTLevelScene).items
                itemNode.addChild(repairNode)
            }
        }
    }
}
