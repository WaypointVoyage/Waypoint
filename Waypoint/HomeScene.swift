//
//  HomeScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    
    let newGame = SKLabelNode(text: "New Game")
    let highScores = SKLabelNode(text: "View High Scores")
    
    override func didMove(to view: SKView) {        
        newGame.position = CGPoint(x: frame.midX, y: frame.midY+30)
        newGame.fontSize = fontSizeMedium
        newGame.fontName = booter
        addChild(newGame)
        
        highScores.position = CGPoint(x: frame.midX, y: frame.midY-15)
        highScores.fontSize = fontSizeMedium
        highScores.fontName = booter
        addChild(highScores)
        
    }
    
    
}
