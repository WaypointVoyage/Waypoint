//
//  WPTLevelEnemyNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelEnemyNode: WPTLevelActorNode {
    
    let enemy: WPTEnemy
    let player: WPTLevelPlayerNode
    
    let brain: WPTBrain
    var brainRadii: WPTBrainRadiiNode? = nil
    let healthBar: WPTHealthNode
    
    var isDead: Bool = false
    
    init(enemy: WPTEnemy, player: WPTLevelPlayerNode, startBrain: Bool = false, health: CGFloat? = nil) {
        self.enemy = enemy
        self.player = player
        self.brain = WPTBrain(self.enemy.brainTemplate, player: self.player)
        let startHealth = health == nil ? enemy.ship.health : health
        self.healthBar = WPTHealthNode(maxHealth: startHealth!, persistent: false)
        super.init(actor: enemy, teamBitMask: WPTValues.enemyTbm)
        
        // brain
        self.brain.enemy = self
        self.brain.setBehavior()
        if startBrain {
            self.brain.start()
        }
        if WPTConfig.values.showBrainRadii {
            self.brainRadii = WPTBrainRadiiNode(brain: self.brain)
            self.brainRadii?.setScale(1.0 / enemy.ship.size) // have to invert enemy scaling to get appropriate sizes
            self.addChild(brainRadii!);
        }
        
        healthBar.shipHealthBar.position = CGPoint(
            x: self.position.x,
            y: self.position.y - WPTValues.fontSizeMedium
        )
        healthBar.setScale(1 / enemy.ship.size)
        self.addChild(healthBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        if brain.started {
            brain.update(deltaTime: deltaTime)
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
        
        // once the enemy is inside the boundary, they will collide with it
        if let phys = self.physics {
            if phys.collisionBitMask & WPTValues.boundaryCbm == 0 {
                if let scene = self.scene as? WPTLevelScene {
                    let terrainBox = CGRect(origin: CGPoint.zero, size: scene.terrain.size)
                    let enemyBoxOrigin = CGPoint(x: self.position.x - self.sprite.frame.width / 2, y: self.position.y - self.sprite.frame.height / 2)
                    let enemyBox = CGRect(origin: enemyBoxOrigin, size: self.sprite.frame.size)
                    if terrainBox.contains(enemyBox) {
                        self.physics?.collisionBitMask |= WPTValues.boundaryCbm
                        self.brain.start()
                    }
                }
            }
        }
    }
    
    override func doDamage(_ damage: CGFloat) {
        print("doing \(damage) damage to a \(self.enemy.name)")
        super.doDamage(damage)
        let alive = healthBar.updateHealth(damage)
        if !alive && self.physics != nil {
            destroyEnemy()
        }
    }
    
    private func destroyEnemy() {
        self.physics = nil // at this point on, there are is no more world interaction
        self.isDead = true
        
        if player.targetNode === self {
            player.targetNode = nil
        }
        
        let explosionNode = SKSpriteNode(imageNamed: "explode")
        explosionNode.position = self.sprite.position
        explosionNode.size = CGSize(width: self.sprite.size.width, height: self.sprite.size.height)
        explosionNode.zPosition = self.sprite.zPosition + WPTValues.fontSizeSmall
        self.addChild(explosionNode)
        
        self.run(SKAction.playSoundFileNamed("cannon.mp3", waitForCompletion: false))
        
        // Don't forget to remove the emitter node after the explosion
        self.run(SKAction.wait(forDuration: 0.5), completion: {
            self.generateCoins()
            explosionNode.removeFromParent()
            if let scene = (self.scene as? WPTLevelScene) {
                scene.terrain.removeEnemy(self)
            }
        })
        
        // actions for observers
        for action in self.deathObservers {
            action()
        }
    }
    
    func generateCoins() {
        guard let itemNode = (self.scene as? WPTLevelScene)?.items else { return }
        let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        for _ in 0..<Int(rand*7) {
            let randomMoney = WPTItemCatalog.randomCurrency()
            let moneyNode = WPTItemNode(randomMoney)
            moneyNode.position = getRandomPosition()
            itemNode.addChild(moneyNode)
        }
    }
    
    func getRandomPosition() -> CGPoint {
        let minWidth = self.position.x - WPTBoulderNode.boulderRadius * 2
        let maxWidth = self.position.x + WPTBoulderNode.boulderRadius * 2
        let minHeight = self.position.y - WPTBoulderNode.boulderRadius * 2
        let maxHeight = self.position.y + WPTBoulderNode.boulderRadius * 2
        
        var rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let xPos = CGFloat(maxWidth - minWidth) * rand + CGFloat(minWidth)
        rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let yPos = CGFloat(maxHeight - minHeight) * rand + CGFloat(minHeight)
        return CGPoint(x: xPos, y: yPos)
    }
}
