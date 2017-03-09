//
//  WPTItemNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/8/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTItemNode: SKNode {
    private let item: WPTItem
    
    let itemImage: SKSpriteNode
    let tier: WPTItemTier
    let multiplicity: Int?
    let prevalence: Int
    let value: Int
    
//    let physics: SKPhysicsBody!
    
    init(_ item: WPTItem) {
        self.item = item
        self.itemImage = SKSpriteNode(imageNamed: self.item.imageName)
        self.tier = item.tier
        self.multiplicity = item.multiplicity
        self.prevalence = item.prevalence
        self.value = item.value
        
        super.init()
        self.physicsBody = SKPhysicsBody(circleOfRadius: 18)
        
        itemImage.scale(to: CGSize(width: 36, height: 36))
        self.addChild(itemImage)
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = WPTValues.itemCbm
        self.physicsBody!.collisionBitMask = WPTValues.actorCbm
        self.physicsBody!.contactTestBitMask = WPTValues.actorCbm
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
