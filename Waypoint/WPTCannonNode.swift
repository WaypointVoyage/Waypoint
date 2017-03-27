//
//  WPTCannonNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTCannonNode: SKNode {
    
    private let cannon: WPTCannon
    
    public private(set) var cannonBallSpawnPoint: CGPoint
    
    let sprite = SKSpriteNode(imageNamed: "cannon")
    
    init(_ cannon: WPTCannon) {
        self.cannon = cannon
        self.cannonBallSpawnPoint = 170 * CGPoint(x: cos(cannon.angle), y: sin(cannon.angle))
        super.init()
        
        self.sprite.anchorPoint = CGPoint(x: 0.25, y: 0.5)
        self.sprite.xScale = 0.5
        self.sprite.yScale = 0.5
        self.addChild(sprite)
        
        self.zPosition = 1
        self.position = cannon.position
        self.zRotation = cannon.angle
        self.cannonBallSpawnPoint += self.position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
