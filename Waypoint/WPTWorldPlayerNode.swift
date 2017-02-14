//
//  WPTWorldPlayerNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/13/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTWorldPlayerNode: SKSpriteNode {
    
    public static let pathSpeed: CGFloat = 250
    
    private static let ungulationScale: Double = 3
    private static let ungulationAmp: Double = 0.5
    
    let player: WPTPlayer
    
    private let ungulationAmp: Double
    
    init(_ player: WPTPlayer) {
        self.player = player
        
        let texture = SKTexture(imageNamed: player.ship.previewImage)
        let size = 0.1 * WPTValues.screenSize.width
        self.ungulationAmp = WPTWorldPlayerNode.ungulationAmp / Double(texture.size().height)
        
        super.init(texture: texture, color: .white, size: CGSize(width: size, height: size))
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval) {
        self.anchorPoint.y += CGFloat(self.ungulationAmp * sin(WPTWorldPlayerNode.ungulationScale * currentTime))
        self.zRotation += CGFloat(0.007 * cos(WPTWorldPlayerNode.ungulationScale * currentTime))
    }
}
