//
//  WPTBubbleSurfaceNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/15/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// TODO: test this

class WPTBubbleSurfaceNode: SKNode {
    
    private static let bubbleTexture = SKTexture(imageNamed: "bubbles")
    private static let fadeSequence = SKAction.sequence([
        SKAction.fadeIn(withDuration: 0.3),
        SKAction.fadeOut(withDuration: 0.3)
    ])

    private let deltaWidth: CGFloat
    private let deltaHeight: CGFloat
    private let period: SKAction
    private var stopped: Bool = true
    
    init(width: CGFloat, height: CGFloat, frequency: CGFloat = 2.0) {
        self.deltaWidth = width / 2.0
        self.deltaHeight = height / 2.0
        self.period = SKAction.wait(forDuration: TimeInterval(1.0 / frequency))
        super.init()
        self.zPosition = 1
    }
    
    public func start() {
        if self.stopped {
            self.stopped = false
            self.runBubbles()
        }
    }
    
    public func stop() {
        self.stopped = true
    }
    
    private func runBubbles() {
        if !self.stopped {
            self.spawnBubbles()
            self.run(self.period, completion: {
                self.runBubbles()
            })
        } else {
            self.removeFromParent()
        }
    }
    
    private func spawnBubbles() {
        let x = randomNumber(min: -deltaWidth, max: deltaWidth)
        let y = randomNumber(min: -deltaHeight, max: deltaHeight)
        
        let sprite = SKSpriteNode(texture: WPTBubbleSurfaceNode.bubbleTexture)
        sprite.alpha = 0
        sprite.position = CGPoint(x: x, y: y)
        self.addChild(sprite)
        
        sprite.run(WPTBubbleSurfaceNode.fadeSequence, completion: {
            sprite.removeFromParent()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
