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
        self.zPosition = WPTZPositions.water - WPTZPositions.terrain + 1
        
        whirlImage.anchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        whirlImage.alpha = 0
        whirlImage.size = CGSize.zero
    }
    
    func start() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: WPTWhirlpoolNode.whirlpoolRadius/1.5)
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = WPTValues.whirlpoolCbm
        self.physicsBody!.collisionBitMask = WPTValues.actorCbm | WPTValues.terrainCbm
        self.physicsBody!.contactTestBitMask = WPTValues.actorCbm
        self.addChild(whirlImage)
        
        let grow = SKAction.resize(toWidth: WPTWhirlpoolNode.whirlpoolRadius * 2, height: WPTWhirlpoolNode.whirlpoolRadius * 2, duration: 1.0)
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        self.whirlImage.run(SKAction.group([grow, fadeIn]))
        let oneRevolution = SKAction.rotate(byAngle: -.pi * 2, duration: 1.0)
        let repeatAction = SKAction.repeatForever(oneRevolution)
        whirlImage.run(repeatAction)
        
        self.run(SKAction.wait(forDuration: 30.0)) {
            self.stop()
        }
    }
    
    func stop() {
        let shrink = SKAction.resize(toWidth: 0, height: 0, duration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        
        self.whirlImage.run(SKAction.group([shrink, fadeOut])) {
            self.removeFromParent()
        }
        
        self.physicsBody = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
