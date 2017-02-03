//
//  WPTSecretMessage.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTSecretMessage: WPTScene {
    
    let color: UIColor = .yellow
    let fontName: String = "HoeflerText-BlackItalic"
    let message1 = WPTLabelNode(text: "HAPPY", fontSize: 90)
    let message2 = WPTLabelNode(text: "BIRTHDAY", fontSize: 90)
    let hilary = WPTLabelNode(text: "HILARY!!!", fontSize: 90)
    let face = WPTLabelNode(text: "🎈 🎂 😀", fontSize: 90)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = .blue
        
        message1.fontName = self.fontName
        message1.fontColor = color
        message1.position = CGPoint(x: frame.midX, y: frame.midY + 105)
        addChild(message1)
        
        message2.fontName = self.fontName
        message2.fontColor = color
        message2.position = CGPoint(x: frame.midX, y: frame.midY + 35)
        addChild(message2)
        
        hilary.fontColor = color
        hilary.fontName = self.fontName
        hilary.position = CGPoint(x: frame.midX, y: frame.midY - 35)
        addChild(hilary)
        
//        face.fontName = "Avenir-Black"
        face.fontColor = color
        face.position = CGPoint(x: frame.midX, y: frame.midY - 125)
        addChild(face)
        
        addChild(WPTHomeScene.getBack(frame: frame))
    }
}
