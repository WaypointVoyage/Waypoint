//
//  WPTPauseMenuNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/15/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPauseMenuNode: SKNode {
    let background = SKSpriteNode(imageNamed: "pause_scroll")
    
    override init() {
        super.init()
        
        self.background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.background.zPosition = WPTValues.pauseShroudZPosition + 1
        let width = 0.9 * WPTValues.screenSize.height
        let scale = width / (self.background.texture?.size().width)!
        self.background.size = CGSize(width: width, height: scale * self.background.texture!.size().height)
        self.background.zRotation = CGFloat(M_PI) / 2.0
        self.addChild(self.background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
