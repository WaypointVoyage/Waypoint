//
//  WPTWhirlpoolNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTWhirlpoolNode: SKNode {
    
    static let whirlpoolRadius: CGFloat = 90.0
    
    let whirlImage = SKSpriteNode(imageNamed: "whirlpool")
    
    override init() {
        super.init()
        
        whirlImage.anchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        whirlImage.size = CGSize(width: WPTWhirlpoolNode.whirlpoolRadius*2, height: WPTWhirlpoolNode.whirlpoolRadius*2)
        self.physicsBody = SKPhysicsBody(circleOfRadius: WPTWhirlpoolNode.whirlpoolRadius)
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = WPTValues.whirlpoolCbm
        self.physicsBody!.collisionBitMask = WPTValues.actorCbm | WPTValues.terrainCbm
        //could be important, it was for my project
        self.addChild(whirlImage)
        let oneRevolution = SKAction.rotate(byAngle: -.pi * 2, duration: 1.0)
        let repeatAction = SKAction.repeatForever(oneRevolution)
        whirlImage.run(repeatAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
