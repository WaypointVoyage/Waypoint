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
    
    init(enemy: WPTEnemy, player: WPTLevelPlayerNode, startBrain: Bool = false) {
        self.enemy = enemy
        self.player = player
        self.brain = WPTBrain(self.enemy.brainTemplate, player: self.player)
        self.healthBar = WPTHealthNode(maxHealth: enemy.ship.health, persistent: false)
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
        if self.physics.collisionBitMask & WPTValues.boundaryCbm == 0 {
            if let scene = self.scene as? WPTLevelScene {
                let terrainBox = CGRect(origin: CGPoint.zero, size: scene.terrain.size)
                let enemyBoxOrigin = CGPoint(x: self.position.x - self.sprite.frame.width / 2, y: self.position.y - self.sprite.frame.height / 2)
                let enemyBox = CGRect(origin: enemyBoxOrigin, size: self.sprite.frame.size)
                if terrainBox.contains(enemyBox) {
                    self.physics.collisionBitMask |= WPTValues.boundaryCbm
                    self.brain.start()
                }
            }
        }
    }
    
    override func doDamage(_ damage: CGFloat) {
        super.doDamage(damage)
        let alive = healthBar.updateHealth(damage)
        if !alive {
            if let scene = (self.scene as? WPTLevelScene) {
                scene.terrain.removeEnemy(self)
            }
        }
    }
}
