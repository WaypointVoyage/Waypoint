//
//  WPTBoulderNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTBoulderNode: SKNode {
    
    static let boulderRadius: CGFloat = 100.0
    
    let boulderImage = SKSpriteNode(imageNamed: "boulder")
    
    override init() {
        super.init()
        
        boulderImage.anchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        boulderImage.size = CGSize(width: WPTBoulderNode.boulderRadius*2, height: WPTBoulderNode.boulderRadius*2)
        self.physicsBody = SKPhysicsBody(circleOfRadius: WPTBoulderNode.boulderRadius*0.6)
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = WPTValues.boulderCbm
        self.physicsBody!.collisionBitMask = WPTValues.actorCbm | WPTValues.terrainCbm | WPTValues.projectileCbm
        //could be important, it was for my project
        self.addChild(boulderImage)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
