//
//  NewGameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class NewGameScene: SKScene {
    let title = SKLabelNode(text: "New Game")
    
    override func didMove(to view: SKView) {
        title.position = CGPoint(x: frame.midX, y: 0.9 * frame.midY)
        title.fontSize = fontSizeLarge
        title.fontName = tradeWinds

        addChild(title)
    }
}
