//
//  WPTTreasureTimerNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTreasureTimerNode: SKNode {
    
    let time = WPTLabelNode(text: "60", fontSize: WPTValues.fontSizeMassive)
    
    let fadeIn = SKAction.fadeIn(withDuration: 0.1)
    let grow = SKAction.scale(to: 1, duration: 0.1)
    let wait = SKAction.wait(forDuration: 0.2)
    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
    
    
    override init() {
        super.init()
        self.zPosition = 1000
        
        time.isHidden = true
        time.alpha = 0
        
        time.horizontalAlignmentMode = .center
        time.verticalAlignmentMode = .center
        self.addChild(time)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(timeVal: String) {
        time.isHidden = false
        time.text = timeVal
        time.setScale(0.1)
        
        let seq = SKAction.sequence([fadeIn, wait, fadeOut])
        
        time.removeAllActions()
        time.run(grow)
        time.run(seq) {
            self.time.isHidden = true
        }
    }
}
