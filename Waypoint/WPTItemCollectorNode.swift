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
    
    private var items = Set<WPTFoundItemEntry>()
    
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
                if let itemPhys = item.item.physicsBody {
                    let offset = CGVector(start: item.item.position, end: target.position)
                    let dist = offset.magnitude()
                    
                    var mag = strength * (radius - dist)
                    clamp(&mag, min: 0, max: strength * radius)
                    mag += pow(item.duration, 3.0) * radius
                    
                    let vel = mag * offset.normalized()
                    itemPhys.velocity = vel
                } else {
                    print("no physics...")
                }
                
                item.duration += CGFloat(deltaTime)
            }
        }
    }
    
    func collect(item: WPTItemNode) {
        self.items.insert(WPTFoundItemEntry(item))
    }
    
    private class WPTFoundItemEntry: Hashable {
        var hashValue: Int
        
        static func ==(lhs: WPTItemCollectorNode.WPTFoundItemEntry, rhs: WPTItemCollectorNode.WPTFoundItemEntry) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        public let item: WPTItemNode
        public var duration: CGFloat = 0
        
        init(_ item: WPTItemNode) {
            self.item = item
            self.hashValue = item.hashValue
        }
    }
}

