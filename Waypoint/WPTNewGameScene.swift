//
//  NewGameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTNewGameScene: SKScene {
    
    let headerLabel = WPTLabelNode(text: "New Game", fontSize: fontSizeLarge)
    let startLabel = WPTLabelNode(text: "Start", fontSize: fontSizeMedium)
    let ship = SKSpriteNode(imageNamed: "WaypointShip")
    
    override func didMove(to view: SKView) {
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        addChild(headerLabel)
        
        startLabel.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        addChild(startLabel)
        
        ship.position = CGPoint(x: frame.midX, y: 0.52 * frame.height)
        addChild(ship)
        addChild(WPTHomeScene.getBack(frame: frame))
    }
}
