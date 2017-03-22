//
//  WPTFinalTreasureNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTFinalTreasureNode: SKNode {
    
    let activationDistance: CGFloat = 600
    
    public private(set) var closed = true
    
    let closedTexture = SKTexture(imageNamed: "treasure_closed")
    let openTexture = SKTexture(imageNamed: "treasure_open")
    let sprite: SKSpriteNode
    
    override init() {
        sprite = SKSpriteNode(texture: closedTexture)
        super.init()
        sprite.anchorPoint = CGPoint(x: 0.35, y: 0.35)
        self.addChild(sprite)
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
