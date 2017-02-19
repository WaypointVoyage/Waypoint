//
//  WPTHudTopNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHudTopNode: SKNode, WPTUpdatable {
    
    private let player: WPTPlayer
    
    let pause = SKSpriteNode(imageNamed: "pause")
    
    init(player: WPTPlayer) {
        self.player = player
        super.init()
        
        let pauseSize = 0.8 * WPTValues.fontSizeSmall
        let pauseOffset = 1.25 * pauseSize
        self.pause.position = CGPoint(x: WPTValues.screenSize.width - pauseOffset, y: WPTValues.screenSize.height - pauseOffset)
        self.pause.size = CGSize(width: pauseSize, height: pauseSize)
        self.pause.zPosition = 1
        self.addChild(self.pause)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
    }
}
