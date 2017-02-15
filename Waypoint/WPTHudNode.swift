//
//  WPTHudNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHudNode: SKNode, WPTUpdatable {
    
    let top: WPTHudTopNode
    let bottom: WPTHudBottomNode
    
    init(player: WPTPlayer) {
        self.top = WPTHudTopNode(player: player)
        self.bottom = WPTHudBottomNode()
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.position = CGPoint.zero
        self.addChild(top)
        self.addChild(bottom)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval) {
        self.top.update(currentTime)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPos = touches.first!.location(in: self)
        if self.top.pause.contains(touchPos) {
            print("pause touched!")
        }
    }
}

