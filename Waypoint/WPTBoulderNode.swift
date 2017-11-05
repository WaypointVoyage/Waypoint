//
//  WPTBoulderNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTBoulderNode: SKNode {
    static let nodeNameTag: String = "_BOULDER"
    
    static let boulderRadius: CGFloat = 80.0
    static let maxBoulderHealth: CGFloat = 100.0
    
    let boulderImage = SKSpriteNode(imageNamed: "boulder")
    let crackedImage = SKSpriteNode(imageNamed: "crackedBoulder")
    let boulderEffect = WPTAudioNode(effect: "explosion")
    var health: WPTHealthNode
    
    override init() {
        self.health = WPTHealthNode(maxHealth: WPTBoulderNode.maxBoulderHealth, persistent: false)
        super.init()
        self.name = WPTBoulderNode.nodeNameTag
        self.zPosition = 4
        
        boulderImage.anchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        boulderImage.size = CGSize(width: WPTBoulderNode.boulderRadius*2, height: WPTBoulderNode.boulderRadius*2)
        crackedImage.anchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        crackedImage.size = CGSize(width: WPTBoulderNode.boulderRadius*2, height: WPTBoulderNode.boulderRadius*2)
        self.physicsBody = SKPhysicsBody(circleOfRadius: WPTBoulderNode.boulderRadius*0.6)
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = WPTValues.boulderCbm
        self.physicsBody!.collisionBitMask = WPTValues.actorCbm | WPTValues.terrainCbm | WPTValues.projectileCbm
        self.physicsBody!.contactTestBitMask = WPTValues.actorCbm | WPTValues.projectileCbm
 
        self.addChild(boulderImage)
        self.addChild(boulderEffect)
        
        self.health.position = CGPoint(
            x: self.position.x,
            y: self.position.y - boulderImage.size.height/2 - 10
        )
        self.addChild(health)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func processHealthStatus(_ healthPoints: CGFloat) {
        let alive = self.health.updateHealth(healthPoints)
        if (!alive) {
            destroyBoulder()
        } else if (self.health.curHealth <= self.health.maxHealth/2.0) {
            self.boulderImage.removeFromParent()
            if (self.crackedImage.parent == nil) {
                self.addChild(crackedImage)
            }
        }
    }
    
    func destroyBoulder() {
        self.health.removeFromParent()
        self.physicsBody = nil
        let explosionNode = SKSpriteNode(imageNamed: "explode")
        explosionNode.position = self.crackedImage.position
        explosionNode.size = CGSize(width: self.crackedImage.size.width, height: self.crackedImage.size.height)
        explosionNode.zPosition = self.crackedImage.zPosition + WPTValues.fontSizeSmall
        self.addChild(explosionNode)
        
        self.boulderEffect.playEffect()
        self.run(SKAction.wait(forDuration: 0.5)) {
            self.generateCoins()
            explosionNode.removeFromParent()
            self.removeFromParent()
        }
    }
    
    func generateCoins() {
        guard let itemNode = (self.scene as? WPTLevelScene)?.items else { return }
        let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        for _ in 0..<Int(rand*7) {
            let randomMoney = WPTItemCatalog.randomCurrency()
            let moneyNode = WPTItemNode(randomMoney, duration: 10.0)
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
