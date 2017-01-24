//
//  NewGameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTNewGameScene: SKScene {
    
    let headerLabel = SKLabelNode(text: "New Game")
    let startLabel = SKLabelNode(text: "Start")
    
    override func didMove(to view: SKView) {
        
        // setup the header
        headerLabel.fontName = booter
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        headerLabel.fontSize = fontSizeLarge
        
        // setup the start label
        startLabel.fontName = booter
        startLabel.position = CGPoint(x: frame.midX, y: 0.12 * frame.midY)
        startLabel.fontSize = fontSizeMedium
        
        addChild(headerLabel)
        addChild(startLabel)
    }
}
