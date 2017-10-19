//
//  WPTAnchorButtonNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 10/18/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTAnchorButtonNode: SKNode {
    
    private let pressedTex = SKTexture(imageNamed: "pressed_anchor_button")
    private let unpressedTex = SKTexture(imageNamed: "anchor_button")
    private let button: SKSpriteNode
    
    override init() {
        let size = CGSize(width: WPTValues.fontSizeMedium*1.2, height: WPTValues.fontSizeMedium*1.2)
        self.button = SKSpriteNode(texture: unpressedTex)
        self.button.size = size
        super.init()
        self.zPosition = WPTZPositions.touchHandler + 2 - WPTZPositions.hud
        
        self.addChild(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startPress() {
        self.button.texture = self.pressedTex
    }
    
    func endPress() {
        self.button.texture = self.unpressedTex
    }
}

