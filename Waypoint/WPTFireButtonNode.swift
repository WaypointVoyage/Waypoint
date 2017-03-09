//
//  WPTFireButtonNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTFireButtonNode: SKNode {
    
    private let pressedTex = SKTexture(imageNamed: "ballButton")
    private let unpressedTex = SKTexture(imageNamed: "cannonButton")
    private let button: SKSpriteNode
    
    override init() {
        let size = CGSize(width: WPTValues.fontSizeMedium*1.1, height: WPTValues.fontSizeMedium*1.1)
        self.button = SKSpriteNode(texture: unpressedTex)
        self.button.size = size
        super.init()
        
        self.zPosition = WPTValues.pauseShroudZPosition + 5
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
