//
//  WPTFinalTreasureNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTFinalTreasureNode: SKNode {
    
    public static let TREASURE_NODE_NAME = "WPT_TREASURE_NODE"
    
    let activationDistance: CGFloat
    
    public private(set) var closed = true
    
    let closedTexture = SKTexture(imageNamed: "treasure_closed")
    let openTexture = SKTexture(imageNamed: "treasure_open")
    let sprite: SKSpriteNode
    
    init(activationDistance: CGFloat = 600) {
        self.activationDistance = activationDistance
        sprite = SKSpriteNode(texture: closedTexture)
        super.init()
        sprite.anchorPoint = CGPoint(x: 0.35, y: 0.35)
        self.addChild(sprite)
        self.zPosition = 10
        
        self.name = WPTFinalTreasureNode.TREASURE_NODE_NAME
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func open() {
        // update state
        self.closed = false
        sprite.texture = openTexture
        
        // spawn coins!
        print("OPENING THE CHEST!")
    }
}
