//
//  WPTLevelTentacleNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/20/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelTentacleNode: WPTLevelEnemyNode {
    private let tentacleEnemy: WPTEnemy
    private var cropNode: SKCropNode! = nil
    
    public let isStatic: Bool
    public private(set) var isSubmerged: Bool = false
    
    private let bubbles: WPTBubbleSurfaceNode
    private var holdPhysics: SKPhysicsBody? = nil
    
    private var surfaceSpritePos: CGPoint! = nil
    private var submergedSpritePos: CGPoint! = nil
    
    init(isStatic: Bool = true, player: WPTLevelPlayerNode, submerged: Bool) {
        self.isStatic = isStatic
        let enemyName = isStatic ? "Static Tentacle" : "Dynamic Tentacle"
        self.tentacleEnemy = WPTEnemyCatalog.enemiesByName[enemyName]!
        
        self.bubbles = WPTBubbleSurfaceNode(width: 100, height: 100, amount: 3)
        
        super.init(enemy: self.tentacleEnemy, player: player)
        
        // physics
        self.physicsBody!.isDynamic = false
        self.holdPhysics = self.physicsBody
        
        // sprite
        self.cropNode = SKCropNode()
        self.cropNode.maskNode = SKSpriteNode(imageNamed: "tentacle_crop")
        self.cropNode.position = self.sprite.position
        self.addChild(cropNode)
        self.sprite.removeFromParent()
        self.cropNode.addChild(self.sprite)
        self.surfaceSpritePos = CGPoint.zero
        self.submergedSpritePos = self.surfaceSpritePos - CGVector(dx: self.sprite.size.width, dy: 0)
        self.sprite.position = self.submergedSpritePos
        
        // bubbles
        self.bubbles.zPosition = -1
        self.addChild(bubbles)
        self.bubbles.start()
        
        // config
        if submerged {
            self.submerge()
        }
    }
    
    func setBubbles(_ value: Bool) {
        if value && self.bubbles.stopped {
            self.bubbles.start()
        } else if !value && !self.bubbles.stopped {
            self.bubbles.stop()
        }
    }
    
    func setPosition(_ position: CGPoint) {
        self.position = position
    }
    
    func submerge(duration: TimeInterval = 1.0, then: (() -> Void)? = nil) {
        guard !self.isSubmerged else { return }
        
        self.physicsBody = nil
        
        self.sprite.run(SKAction.move(to: self.submergedSpritePos, duration: duration)) {
            self.isSubmerged = true
            if let then = then {
                then()
            }
        }
    }
    
    func surface(duration: TimeInterval = 1.0, then: (() -> Void)? = nil) {
        guard self.isSubmerged else { return }
        
        self.physicsBody = self.holdPhysics
        
        self.sprite.run(SKAction.move(to: self.surfaceSpritePos, duration: duration)) {
            self.isSubmerged = false
            if let then = then {
                then()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
