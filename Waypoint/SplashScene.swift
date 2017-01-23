//
//  GameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/16/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class SplashScene: SKScene {
    
    let fontName = booter
    
    let titleNode = SKLabelNode(text: gameName)
    let tapToCont = SKLabelNode(text: "Tap to continue...")
    let fadeIn = SKAction.fadeIn(withDuration: 3.0)
    
    var canProceed = false
    
    override func didMove(to view: SKView) {
        
        // setup the title
        setup(label: titleNode)
        titleNode.fontSize = fontSizeTitle
        titleNode.fontColor = .cyan
        titleNode.position = CGPoint(x: frame.midX, y: frame.midY)
        
        // tap to continue...
        setup(label: tapToCont)
        tapToCont.fontSize = fontSizeSmall
        tapToCont.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        
        // fade in all fancy
        titleNode.run(.fadeIn(withDuration: 3.0)) {
            self.canProceed = true
            self.tapToCont.run(.fadeIn(withDuration: 0.4))
        }
    }
    
    func setup(label: SKLabelNode) {
        label.zPosition = 1
        label.alpha = 0
        label.fontName = self.fontName
        self.addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!self.canProceed) {
            return
        }
        
        let homeScene = HomeScene()
        homeScene.scaleMode = .resizeFill
        self.scene?.view?.presentScene(homeScene)
    }

}
