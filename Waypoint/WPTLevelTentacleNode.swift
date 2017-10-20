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
    
    public let isStatic: Bool
    public private(set) var isSubmerged: Bool = false
    
    private let bubbles: WPTBubbleSurfaceNode
    private var holdPhysics: SKPhysicsBody? = nil
    
    init(isStatic: Bool = true, player: WPTLevelPlayerNode, submerged: Bool) {
        self.isStatic = isStatic
        let enemyName = isStatic ? "Static Tentacle" : "Dynamic Tentacle"
        self.tentacleEnemy = WPTEnemyCatalog.enemiesByName[enemyName]!
        
        self.bubbles = WPTBubbleSurfaceNode(width: 100, height: 100)
        
        super.init(enemy: self.tentacleEnemy, player: player)
        self.holdPhysics = self.physicsBody
        
        self.addChild(bubbles)
        self.bubbles.start()
        
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
