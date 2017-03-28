//
//  WPTReticleNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/21/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTReticleNode: SKNode, WPTUpdatable {
    static let _name = "_RETICLE"
    static let scale: CGFloat = 0.4
    
    var target: SKNode? = nil
    
    let texture = SKTexture(imageNamed: "reticle_arrow")
    var top: SKSpriteNode!
    var bottom: SKSpriteNode!
    var left: SKSpriteNode!
    var right: SKSpriteNode!
    
    var attached: Bool {
        return target != nil
    }
    
    override init() {
        top = SKSpriteNode(texture: texture)
        bottom = SKSpriteNode(texture: texture)
        left = SKSpriteNode(texture: texture)
        right = SKSpriteNode(texture: texture)
        super.init()
        self.name = WPTReticleNode._name
        self.zPosition = WPTZPositions.hud - 1
        
        for sprite in [top, bottom, left, right] {
            sprite!.anchorPoint = CGPoint(x: 0.5, y: 0)
            self.addChild(sprite!)
        }
        
        bottom.zRotation = CG_PI
        left.zRotation = CG_PI/2.0
        right.zRotation = -CG_PI/2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        let offset: CGFloat = 30 + CGFloat(sin(6 * currentTime) * 15)
        top.position.y = offset
        bottom.position.y = -offset
        left.position.x = -offset
        right.position.x = offset
    }
    
    func track(node: SKNode) {
        self.target = node
        self.xScale = WPTReticleNode.scale / node.xScale
        self.yScale = WPTReticleNode.scale / node.yScale
        self.removeFromParent()
        self.target?.addChild(self)
    }
    
    func remove() {
        self.target = nil
        self.removeFromParent()
    }
}
