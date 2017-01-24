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
    let secretMessage = WPTSceneLabelNode(text: "Secret Message...", next: WPTSecretMessage())
    
    override func didMove(to view: SKView) {        
        newGame.position = CGPoint(x: frame.midX, y: frame.midY+30)
        addChild(newGame)
        
        highScores.position = CGPoint(x: frame.midX, y: frame.midY-15)
        addChild(highScores)
        
        secretMessage.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        secretMessage.fontSize = fontSizeMiniscule
        addChild(secretMessage)
    }
    
    static func getBack(frame: CGRect) -> SKLabelNode {
        let back = WPTSceneLabelNode(text: "<Back", next: WPTHomeScene())
        back.position = CGPoint(x: 0.1 * frame.width, y: 0.1 * frame.height)
        return back
    }
}
