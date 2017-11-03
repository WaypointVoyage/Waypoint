//
//  WPTBubbleSurfaceNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/15/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTBubbleSurfaceNode: SKNode {
    private static let bubbleTexture = SKTexture(imageNamed: "bubbles")
    let bubbleEffect = WPTAudioNode(effect: "bubbles.wav")
    
    private var bubbles: [SKSpriteNode] = [SKSpriteNode]()
    
    private let fadeSequence: SKAction
    
    private let time: TimeInterval
    private let amount: Int
    public private(set) var stopped: Bool = true
    
    init(amount: Int = 1, time: TimeInterval = 0.6) {
        self.time = time
        self.amount = amount
        self.fadeSequence = SKAction.sequence([
            SKAction.fadeIn(withDuration: time / 2.0),
            SKAction.fadeOut(withDuration: time / 2.0)
        ])
        
        super.init()
        
        for _ in 0..<amount {
            let b = SKSpriteNode(texture: WPTBubbleSurfaceNode.bubbleTexture)
            b.alpha = 0
            self.bubbles.append(b)
            self.addChild(b)
        }
        
        self.bubbleEffect.setLoop(looped: true)
        self.addChild(bubbleEffect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        guard self.stopped else { return }
        
        for bubble in self.bubbles {
            self.kickoffBubbles(bubble)
        }
        self.bubbleEffect.playEffect()
        self.stopped = false
    }
    
    public func stop() {
        guard !self.stopped else { return }
        
        for bubble in self.bubbles {
            bubble.removeAllActions()
        }
        self.bubbleEffect.stopEffect()
        self.stopped = true
    }
    
    private func kickoffBubbles(_ bubbles: SKNode) {
        let delay = randomNumber(min: 0.0, max: CGFloat(self.time))
        self.run(SKAction.wait(forDuration: TimeInterval(delay))) {
            self.bubbleCycle(bubbles)
        }
    }
    
    private func bubbleCycle(_ bubbles: SKNode) {
        bubbles.position = self.getRandomBubblePosition()
        bubbles.run(self.fadeSequence) {
            self.bubbleCycle(bubbles)
        }
    }
    
    // override this to create different surface shapes
    public func getRandomBubblePosition() -> CGPoint {
        return CGPoint.zero
    }
}

class WPTBubbleSquareSurfaceNode: WPTBubbleSurfaceNode {
    
    private let deltaX: CGFloat
    private let deltaY: CGFloat
    
    init(width: CGFloat, height: CGFloat, amount: Int, time: TimeInterval) {
        self.deltaX = width / 2.0
        self.deltaY = height / 2.0
        super.init(amount: amount, time: time)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getRandomBubblePosition() -> CGPoint {
        return CGPoint(
            x: randomNumber(min: -self.deltaX, max: self.deltaX),
            y: randomNumber(min: -self.deltaY, max: self.deltaY)
        )
    }
}
