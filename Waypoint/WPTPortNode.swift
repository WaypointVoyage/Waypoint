//
//  WPTPortNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPortNode: SKNode {
    let port: WPTPort
    
    let sprite = SKSpriteNode(imageNamed: "port")
    
    init(port: WPTPort) {
        self.port = port;
        super.init()
        let scale: CGFloat = 0.25
        
        self.zRotation = port.angle
        self.position = 2 * port.position
        self.xScale = scale
        self.yScale = scale
        self.zPosition = WPTValues.actorZPosition - 1
        
        sprite.anchorPoint = CGPoint(x: 0.2, y: 0.5)
        self.addChild(sprite)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: scale * self.sprite.frame.size.width, height: scale * self.sprite.frame.size.height), center: CGPoint(x: 0.15 * self.sprite.frame.width / 2, y: 0))
        self.physicsBody!.categoryBitMask = WPTValues.terrainCbm
        self.physicsBody!.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
