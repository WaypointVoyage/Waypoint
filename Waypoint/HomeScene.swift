//
//  HomeScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    
    let text = SKLabelNode(text: "Menu")
    
    override func didMove(to view: SKView) {
        print("Moved to Home Scene!")
        
        text.position = CGPoint(x: frame.midX, y: frame.midY)
        text.fontSize = 70
        text.fontName = tradeWinds
        addChild(text)
    }
}
