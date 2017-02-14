//
//  WPTWorldPlayerNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/13/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTWorldPlayerNode: SKSpriteNode {
    
    private static let ungulationScale: Double = 3
    
    let player: WPTPlayer
    
    init(_ player: WPTPlayer) {
        self.player = player
        
        let texture = SKTexture(imageNamed: player.ship.previewImage)
        let size = 0.1 * WPTValues.screenSize.width
        super.init(texture: texture, color: .white, size: CGSize(width: size, height: size))
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval) {
        self.anchorPoint.y += CGFloat(0.005 * sin(WPTWorldPlayerNode.ungulationScale * currentTime))
        self.zRotation += CGFloat(0.01 * cos(WPTWorldPlayerNode.ungulationScale * currentTime))
    }
}
