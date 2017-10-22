//
//  WPTItemNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/8/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTItemNode: SKNode {
    private static let currencySize: CGFloat = 36
    private static let itemSize: CGFloat = 84
    
    let item: WPTItem
    
    let itemImage: SKSpriteNode
    
    init(_ item: WPTItem, duration: TimeInterval? = nil) {
        self.item = item
        self.itemImage = SKSpriteNode(imageNamed: self.item.imageName)
        super.init()
        
        let size = item.tier == WPTItemTier.currency ? WPTItemNode.currencySize : WPTItemNode.itemSize
        self.physicsBody = SKPhysicsBody(circleOfRadius: size / 2)
        itemImage.scale(to: CGSize(width: size, height: size))
        self.addChild(itemImage)
        self.physicsBody!.categoryBitMask = WPTValues.itemCbm
        self.physicsBody!.contactTestBitMask = WPTValues.actorCbm | WPTValues.itemCollectionCbm
        self.physicsBody!.collisionBitMask = 0
        self.physicsBody!.allowsRotation = false
        
        self.zPosition = WPTZPositions.actors - WPTZPositions.terrain
        
        if let dur = duration {
            self.setDuration(dur)
        }
    }
    
    private func setDuration(_ duration: TimeInterval) {
        
        // live for a while
        let life = SKAction.wait(forDuration: duration)
        self.run(life) {
            
            // flash for a bit to let the player know we are disappearing
            self.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.1),
                SKAction.wait(forDuration: 0.2),
                SKAction.fadeIn(withDuration: 0.1),
                SKAction.wait(forDuration: 0.5)
            ])))
            
            // remove from parent after flashing for a bit
            let flashingDuraiton = SKAction.wait(forDuration: 5.0)
            self.run(flashingDuraiton) {
                self.removeAllActions()
                self.removeFromParent()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
