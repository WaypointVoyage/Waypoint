//
//  WPTSwitchNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 10/30/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

class WPTSwitchNode: SKNode {

    let switchOn = SKTexture(imageNamed: "switch_on")
    let switchOff = SKTexture(imageNamed: "switch_off")
    let switchButton: SKSpriteNode
    let title: WPTLabelNode!
    
    var switchedOn = false
    
    init(title: String, switchValue: Bool = false) {
        self.switchButton = SKSpriteNode()
        
        self.title = WPTLabelNode(text: title, fontSize: WPTValues.fontSizeSmall)
        self.switchedOn = switchValue
        super.init()
        
        makeSwitch()
        
        self.title.fontColor = UIColor.black
        self.title.position = CGPoint(x: -self.title!.fontSize * 2.4, y: 0.5)
        
        self.switchButton.zPosition = 2.0
        self.switchButton.anchorPoint = CGPoint(x: 0, y: 0.5)
        let switchButtonSize = 0.1 * WPTValues.screenSize.width
        switchButton.size = CGSize(width: switchButtonSize / 1.15, height: switchButtonSize / 1.2)
        
        self.addChild(self.switchButton)
        self.addChild(self.title)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            if (switchButton.contains(touchLocation)) {
                makeSwitch()
            }
        }
    }
    
    func makeSwitch() {
        if (switchedOn) {
            switchButton.texture = switchOn
        } else {
            print("yo")
            switchButton.texture = switchOff
        }
        switchedOn = !switchedOn
    }
}
