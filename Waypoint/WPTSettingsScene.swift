//
//  WPTSettingsScene.swift
//  Waypoint
//
//  Created by Hilary Schulz on 1/26/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTSettingsScene: WPTScene {
    
    let background = WPTBackgroundNode(image: "beach_scene")
    let headerLabel = WPTLabelNode(text: "Settings", fontSize: WPTValues.fontSizeLarge)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        headerLabel.fontColor = UIColor.black
        addChild(headerLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
        
        // add background
        background.position(for: self)
        addChild(background)
    }
}
