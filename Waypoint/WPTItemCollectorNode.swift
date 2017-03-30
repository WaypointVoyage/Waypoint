//
//  WPTItemCollectorNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/30/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTItemCollectorNode: SKNode, WPTUpdatable {
   
    let radius: CGFloat
    let strength: CGFloat
    weak var target: SKNode?
    var offset: CGPoint = CGPoint.zero
    
    var items = Set<WPTItemNode>()
    
    init(target: SKNode, radius: CGFloat, strength: CGFloat = 0.2) {
        self.radius = radius
        self.target = target
        self.strength = strength
        super.init()
        self.zPosition = -1
        
        // physics setup
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody!.categoryBitMask = WPTValues.itemCollectionCbm
        self.physicsBody!.contactTestBitMask = WPTValues.itemCbm
        self.physicsBody!.collisionBitMask = 0 // wont cause any physical interactions, but will still allow contact detection (unlike .isDynamic = false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        self.position = offset
        
        if let target = target {
            for item in items {
                if let itemPhys = item.physicsBody {
                    let offset = CGVector(start: item.position, end: target.position)
                    let dist = offset.magnitude()
                    let force = strength * (radius - dist) * offset.normalized()
                    itemPhys.applyForce(force)
                } else {
                    print("no physics...")
                }
            }
        }
    }
}
