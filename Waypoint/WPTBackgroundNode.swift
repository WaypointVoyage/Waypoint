//
//  WPTBackgroundNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTBackgroundNode: SKSpriteNode {

    let backgroundTexture: SKTexture
    let aspectRatio: CGFloat
    
    init(image: String) {
        backgroundTexture = SKTexture(imageNamed: image)
        self.aspectRatio = self.backgroundTexture.size().width / self.backgroundTexture.size().height
        super.init(texture: self.backgroundTexture, color: UIColor.white, size: self.backgroundTexture.size())
        self.zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func position(for scene: WPTScene) {
        self.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        self.setScale(scene.frame.width / self.backgroundTexture.size().width)
    }
}
