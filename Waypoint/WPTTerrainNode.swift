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
    
    init(level: WPTLevel) {
        self.level = level
        self.size = CGSize(width: 1080 * 5, height: 1080 * 5)
        self.spawnPoint = CGPoint(x: self.size.width / 3.0, y: self.size.height / 2.0)
        super.init()
        
        let water = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: self.size))
        water.fillShader = self.waterShader
        water.strokeColor = UIColor.green
        water.lineWidth = 5
        water.zPosition = -100
        self.addChild(water)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
