//
//  WPTTerrainNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/16/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTerrainNode: SKNode {
    private let waterShader = SKShader(fileNamed: "water.fsh")
    
    let level: WPTLevel
    let size: CGSize
    let spawnPoint: CGPoint
    
    var boundary: SKPhysicsBody!
    
    init(level: WPTLevel) {
        self.level = level
        self.size = level.size
        self.spawnPoint = level.spawnPoint
        self.boundary = nil
        super.init()
        self.isUserInteractionEnabled = true
        
        // setup the water backdrop
        let water = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: self.size))
        water.fillShader = self.waterShader
        water.strokeColor = UIColor.purple
        water.lineWidth = 5
        water.zPosition = -100
        self.addChild(water)
        
        // put a boundary on the scene
        self.boundary = SKPhysicsBody(edgeLoopFrom: water.frame)
        self.physicsBody = boundary
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let player = self.childNode(withName: WPTLevelScene.playerNameTag) as? WPTLevelPlayerNode {
            if let target = touches.first?.location(in: self) {
                player.facePoint(target)
            }
        }
    }
}
