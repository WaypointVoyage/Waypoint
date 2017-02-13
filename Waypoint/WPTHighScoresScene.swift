//
//  WPTHighScoresScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHighScoresScene: WPTScene {
    
    let titleLabel = WPTLabelNode(text: "High Scores", fontSize: WPTValues.fontSizeLarge)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        titleLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        addChild(titleLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
    }
    
}
