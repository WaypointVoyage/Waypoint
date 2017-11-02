//
//  WPTHighScoresScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHighScoresScene: WPTScene {
    
    let background = WPTBackgroundNode(image: "beach_scene")
    let titleLabel = WPTLabelNode(text: "High Scores", fontSize: WPTValues.fontSizeLarge)
    
    let scoresTable = SKNode()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        titleLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        titleLabel.fontColor = UIColor.black
        addChild(titleLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
        
        let storage = WPTStorage()
        var scores = storage.loadHighScores()
        let extra = scores.count - 10
        if extra > 0 {
            scores.removeLast(extra)
        }
        
        // build the high scores table
        scoresTable.removeAllChildren()
        scoresTable.position = CGPoint(x: 0.5 * WPTValues.screenSize.width, y: 0.75 * WPTValues.screenSize.height)
        let fontSize = (WPTValues.screenSize.height - WPTValues.fontSizeLarge - 2.9 * WPTValues.fontSizeMedium) / 10.0
        let rankX: CGFloat = -0.45 * WPTValues.screenSize.width
        let shipNameX: CGFloat = -0.38 * WPTValues.screenSize.width
        let doubloonsX: CGFloat = 0.4 * WPTValues.screenSize.width
        
        // add the rows to the table
        for i in 0..<scores.count {
            let score = scores[i]
            
            // make a new row
            let scoreRow = SKNode()
            scoreRow.position.y -= CGFloat(i) * fontSize
            scoresTable.addChild(scoreRow)
            
            // rank
            let rank = WPTLabelNode(text: String(i + 1), fontSize: fontSize)
            rank.horizontalAlignmentMode = .right
            rank.position.x = rankX
            rank.fontColor = .black
            scoreRow.addChild(rank)
            
            // ship name
            let shipName = WPTLabelNode(text: score.shipName, fontSize: fontSize)
            shipName.horizontalAlignmentMode = .left
            shipName.fontColor = .black
            shipName.position.x = shipNameX
            scoreRow.addChild(shipName)
            
            // score
            let doubloons = WPTLabelNode(text: String(score.doubloons), fontSize: fontSize)
            doubloons.horizontalAlignmentMode = .left
            doubloons.position.x = doubloonsX
            doubloons.fontColor = .black
            scoreRow.addChild(doubloons)
        }
        
        // add background
        background.position(for: self)
        addChild(background)
       
       self.addChild(scoresTable)
    }
    
}
