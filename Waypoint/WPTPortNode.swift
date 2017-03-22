//
//  WPTPortNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPortNode: SKNode {
    let port: WPTPort
    var active: Bool
    
    let sprite = SKSpriteNode(imageNamed: "port")
    
    init(port: WPTPort, active: Bool = false) {
        self.port = port;
        self.active = active
        super.init()
        let scale: CGFloat = 0.25
        
        self.zRotation = port.angle
        self.position = 2 * port.position
        self.xScale = scale
        self.yScale = scale
        self.zPosition = WPTValues.actorZPosition - 1
        
        sprite.anchorPoint = CGPoint(x: 0.2, y: 0.5)
        self.addChild(sprite)
        
        // setup physics
        let height = scale * self.sprite.frame.height
        let width = scale * self.sprite.frame.width
        let physSize = CGSize(width: width, height: height)
        let physCenter = CGPoint(x: 0.15 * self.sprite.frame.width / 2, y: 0)
        self.physicsBody = SKPhysicsBody(rectangleOf: physSize, center: physCenter)
        self.physicsBody!.categoryBitMask = WPTValues.terrainCbm
        self.physicsBody!.isDynamic = false
        
        // add player capture volumes
        let docks: [WPTDockNode] = [WPTDockNode(self), WPTDockNode(self)]
        for dock in docks {
            let size = CGSize(width: 0.6 * self.sprite.size.width, height: 0.35 * self.sprite.size.height)
            dock.position = CGPoint(x: 0.8 * size.width, y: 2 * size.height)
            dock.physicsBody = SKPhysicsBody(rectangleOf: size)
            dock.physicsBody!.isDynamic = false
            dock.physicsBody!.categoryBitMask = WPTValues.dockCbm
            dock.physicsBody!.contactTestBitMask = WPTValues.actorCbm
            self.addChild(dock)
        }
        docks[1].position.y *= -1
        
        let endDock = WPTDockNode(self, rotation: self.zRotation + CG_PI/2)
        let endDockSize = CGSize(width: 0.2 * self.sprite.size.width, height: self.sprite.size.height)
        endDock.physicsBody = SKPhysicsBody(rectangleOf: endDockSize)
        endDock.physicsBody!.isDynamic = false
        endDock.physicsBody!.categoryBitMask = WPTValues.dockCbm
        endDock.physicsBody!.contactTestBitMask = WPTValues.actorCbm
        endDock.position.x += 0.9 * self.sprite.size.width
        self.addChild(endDock)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
