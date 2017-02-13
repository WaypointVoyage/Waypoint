//
//  WPTSettingsScene.swift
//  Waypoint
//
//  Created by Hilary Schulz on 1/26/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTSettingsScene: WPTScene {
    
    let headerLabel = WPTLabelNode(text: "Settings", fontSize: WPTValues.fontSizeLarge)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        addChild(headerLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
    }
}
