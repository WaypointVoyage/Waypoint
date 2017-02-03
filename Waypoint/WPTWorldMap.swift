//
//  WPTWorldMap.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/3/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

class WPTWorldMap: SKSpriteNode {
    let mapTexture = SKTexture(imageNamed: "worldmap")
    let aspectRatio: CGFloat
    
    init() {
        self.aspectRatio = self.mapTexture.size().width / self.mapTexture.size().height
        super.init(texture: self.mapTexture, color: UIColor.white, size: self.mapTexture.size())
        self.zPosition = -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func position(for scene: WPTScene) {
        self.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        self.setScale(scene.frame.width / self.mapTexture.size().width)
    }
}
