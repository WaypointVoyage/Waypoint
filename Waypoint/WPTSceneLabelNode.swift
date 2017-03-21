//
//  WPTSceneLabelNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTSceneLabelNode: WPTLabelNode {
    
    static let fontSize = WPTValues.fontSizeMedium
    
    var nextScene: SKScene?
    var useSound = true
    
    override init() {
        super.init()
    }
    
    init(text: String, next: SKScene) {
        super.init(text: text, fontSize: WPTSceneLabelNode.fontSize)
        self.nextScene = next
        self.isUserInteractionEnabled = true
        self.verticalAlignmentMode = .top
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scene?.view?.presentScene(nextScene)
    }
}
