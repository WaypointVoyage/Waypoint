//
//  WPTButtonNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/21/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTButtonNode: SKNode {
    
    var label: WPTLabelNode
    var background =  SKSpriteNode(imageNamed: "plank")
    var disabled: Bool {
        get {
            return label.alpha < 0.7
        }
        set(disable) {
            if (disable) {
                label.alpha = 0.6
            } else {
                label.alpha = 1.0
            }
        }
    }
    
    
    init(text: String, fontSize: CGFloat) {
        label = WPTLabelNode(text: text, fontSize: fontSize)
        label.fontColor = UIColor.white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        
        super.init()
        self.zPosition = WPTZPositions.hud + 1
        
        let height = 1.5 * fontSize
        let width = label.frame.width + fontSize
        background.size = CGSize(width: width, height: height)
        self.addChild(background)
        
        self.label.zPosition = 1
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
