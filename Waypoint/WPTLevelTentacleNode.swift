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
    private let riseShader: SKShader
    
    public let isStatic: Bool
    public private(set) var isSubmerged: Bool = false
    
    private let bubbles: WPTBubbleSurfaceNode
    private var holdPhysics: SKPhysicsBody? = nil
    
    private var submergeOffset: CGFloat {
        return self.sprite.size.width
    }
    
    init(isStatic: Bool = true, player: WPTLevelPlayerNode, submerged: Bool) {
        self.isStatic = isStatic
        let enemyName = isStatic ? "Static Tentacle" : "Dynamic Tentacle"
        self.tentacleEnemy = WPTEnemyCatalog.enemiesByName[enemyName]!
        
        self.riseShader = SKShader(fileNamed: "tentacle_rise.fsh")
        
        self.bubbles = WPTBubbleSurfaceNode(width: 100, height: 100, amount: 3)
        
        super.init(enemy: self.tentacleEnemy, player: player)
        
        // physics
        self.physicsBody!.isDynamic = false
        self.holdPhysics = self.physicsBody
        
        // sprite
        self.sprite.shader = self.riseShader
        
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
    
    func submerge(then: (() -> Void)? = nil) {
        guard !self.isSubmerged else { return }
        // TODO: get fancy with falling into the water
        self.sprite.removeFromParent()
        
        self.physicsBody = nil
        
        self.run(SKAction.wait(forDuration: 1.0)) { // simulate a delay
            self.isSubmerged = true
            if let then = then {
                then()
            }
        }
    }
    
    func surface(then: (() -> Void)? = nil) {
        guard self.isSubmerged else { return }
        // TODO: get fancy with rising from the water
        self.addChild(self.sprite)
        
        self.physicsBody = self.holdPhysics
        
        self.run(SKAction.wait(forDuration: 1.0)) {
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
