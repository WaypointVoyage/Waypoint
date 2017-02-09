//
//  WPTSceneLabelNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTSceneLabelNode: WPTLabelNode {
    
    var nextScene: SKScene?
    var useSound = true
    
//    let soundEffect = SKAction.playSoundFileNamed("sword1.caf", waitForCompletion: false)
    
    override init() {
        super.init()
    }
    
    init(text: String, next: SKScene) {
        super.init(text: text, fontSize: fontSizeMedium)
        self.nextScene = next
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.useSound && WPTConfig.values.playSoundEffects {
            print("running sound effect")
//            self.run(soundEffect)
        }
        self.scene?.view?.presentScene(nextScene)
    }
}
