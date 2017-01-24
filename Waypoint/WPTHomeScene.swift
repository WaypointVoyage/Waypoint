//
//  HomeScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHomeScene: SKScene {
    
    let newGame = WPTSceneLabelNode(text: "New Game", next: WPTNewGameScene())
    let highScores = WPTSceneLabelNode(text: "High Scores", next: WPTHighScoresScene())
    
    override func didMove(to view: SKView) {        
        newGame.position = CGPoint(x: frame.midX, y: frame.midY+30)
        addChild(newGame)
        
        highScores.position = CGPoint(x: frame.midX, y: frame.midY-15)
        addChild(highScores)
    }
}
