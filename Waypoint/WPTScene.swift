//
//  WPTScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/2/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTScene: SKScene {
    
    var aspectRatio: CGFloat = 1.0
    
    override func didMove(to view: SKView) {
        self.scaleMode = SKSceneScaleMode.resizeFill
        self.size = view.frame.size
        
        self.aspectRatio = self.size.width / self.size.height
    }
}
