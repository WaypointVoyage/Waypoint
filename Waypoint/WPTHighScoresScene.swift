//
//  WPTHighScoresScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHighScoresScene: SKScene {
    
    let titleLabel = WPTLabelNode(text: "High Scores", fontSize: fontSizeLarge)
    
    override func didMove(to view: SKView) {
        
        titleLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        addChild(titleLabel)
        
        let back = WPTSceneLabelNode(text: "<Back", next: WPTHomeScene())
        back.position = CGPoint(x: 0.1 * frame.width, y: 0.1 * frame.height)
        addChild(back)
    }
    
}
