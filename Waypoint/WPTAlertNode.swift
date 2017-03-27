//
//  WPTAlertNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/21/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTAlertNode: SKNode {
    
    let header: WPTLabelNode
    let desc: WPTLabelNode
    
    override init() {
        self.header = WPTLabelNode(text: "header", fontSize: WPTValues.fontSizeKindaSmall)
        self.desc = WPTLabelNode(text: "description", fontSize: WPTValues.fontSizeTiny)
        super.init()
        self.alpha = 0
        self.isHidden = true
        self.zPosition = WPTZPositions.hud
        
        for label in [header, desc] {
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            label.fontColor = .black
            self.addChild(label)
        }
        
        header.position.y += 3.5 * desc.frame.height
        desc.position.y += 1.6 * desc.frame.height
    }
    
    func show(header: String, desc: String) {
        self.header.text = header
        self.desc.text = desc
        
        self.isHidden = false
        let show = SKAction.fadeIn(withDuration: 0.3)
        let wait = SKAction.wait(forDuration: 2)
        let hide = SKAction.fadeOut(withDuration: 0.5)
        self.removeAllActions()
        self.run(SKAction.sequence([show, wait, hide])) {
            self.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
