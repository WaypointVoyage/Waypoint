//
//  GameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/16/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        // setup the title
        let titleNode = SKLabelNode(text: "Waypoint")
        titleNode.zPosition = 1
        titleNode.fontSize = 80
        titleNode.fontName = "Zapfino"
        titleNode.fontColor = .cyan
        titleNode.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(titleNode)
        
    }

}
