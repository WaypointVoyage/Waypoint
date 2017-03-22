//
//  WPTHighScoresScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHighScoresScene: WPTScene {
    
    let background = WPTBackgroundNode(image: "ocean3")
    let titleLabel = WPTLabelNode(text: "High Scores", fontSize: WPTValues.fontSizeLarge)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        titleLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        titleLabel.fontColor = UIColor.black
        addChild(titleLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
        
        let storage = WPTStorage()
        let scores = storage.loadHighScores(count: nil)
        print("found \(scores.count) scores")
        for score in scores {
            print("\t - \(score.shipName): \(score.doubloons) at \(score.date)")
        }
        
        // add background
        background.position(for: self)
        addChild(background)
    }
    
}
