//
//  WPTAchoredIndicatorNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 4/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTAnchoredIndicatorNode: SKSpriteNode {
    private static let IS_ANCHORED_UNIFORM_NAME = "is_anchored"
    
    private let isAnchored = SKUniform(name: WPTAnchoredIndicatorNode.IS_ANCHORED_UNIFORM_NAME, float: 1.0)
    
    init() {
        let texture = SKTexture(imageNamed: "anchored_indicator")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.setScale(0.05)
        
        self.shader = SKShader(fileNamed: "anchored_indicator.fsh")
        self.shader!.addUniform(isAnchored)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAnchored(_ anchored: Bool) {
        self.shader!.uniformNamed(WPTAnchoredIndicatorNode.IS_ANCHORED_UNIFORM_NAME)?.floatValue = anchored ? 1.0 : 0.0;
    }
}
