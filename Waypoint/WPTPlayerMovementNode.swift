//
//  WPTPlayerMovementTouchHandler.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/25/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPlayerMovementNode: SKNode {
    
    private let player: WPTLevelPlayerNode
    private let showShroud = false
    
    init(_ size: CGSize, _ player: WPTLevelPlayerNode) {
        self.player = player
        super.init()
        self.isUserInteractionEnabled = true
        
        let handler = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: size))
        if showShroud {
            handler.fillColor = UIColor(colorLiteralRed: 1, green: 0, blue: 0, alpha: 0.6)
        }
        handler.zPosition = WPTValues.movementHandlerZPosition
        self.addChild(handler)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let target = touches.first?.location(in: self) {
            player.facePoint(target)
        }
        
//        if let scene = self.scene as? WPTLevelScene {
//            let point = scene.convert(touches.first!.location(in: self), from: self)
//            let onLand = scene.terrain.pointOnLand(scenePoint: point)
//        }
    }
}
