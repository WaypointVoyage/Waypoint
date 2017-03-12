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
    
    init(_ item: WPTItem) {
        self.item = item
        self.itemImage = SKSpriteNode(imageNamed: self.item.imageName)
        super.init()
        
        let size = item.tier == WPTItemTier.currency ? WPTItemNode.currencySize : WPTItemNode.itemSize
        self.physicsBody = SKPhysicsBody(circleOfRadius: size / 2)
        itemImage.scale(to: CGSize(width: size, height: size))
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
