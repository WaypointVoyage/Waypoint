//
//  GameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/16/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTSplashScene: WPTScene {
    
    let background = WPTWorldMapNode()
    
    let titleNode = WPTLabelNode(text: gameName, fontSize: fontSizeTitle)
    let tapToCont = WPTLabelNode(text: "Tap to continue...", fontSize: fontSizeSmall)
    let fadeIn = SKAction.fadeIn(withDuration: 3.0)
    
    var canProceed = false
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // add the map to the background
        background.position(for: self)
        addChild(background)
        
        // setup the title
        titleNode.alpha = 0
        titleNode.fontColor = .black
        titleNode.position = CGPoint(x: frame.midX, y: 0.75 * frame.height)
        addChild(titleNode)
        
        // tap to continue...
        tapToCont.alpha = 0
        tapToCont.fontColor = .black
        tapToCont.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        addChild(tapToCont)
        
        // fade in all fancy
        titleNode.run(.fadeIn(withDuration: 2.0)) {
            self.canProceed = true
            self.tapToCont.run(.fadeIn(withDuration: 0.4))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.canProceed || WPTConfig.values.testing) {
            self.scene?.view?.presentScene(WPTHomeScene())
        }
    }

}
