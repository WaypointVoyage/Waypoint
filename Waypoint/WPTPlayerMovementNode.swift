//
//  WPTPlayerMovementTouchHandler.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/25/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelTouchHandlerNode: SKNode {
    
    private let player: WPTLevelPlayerNode
    private let levelScene: WPTLevelScene
    
    init(_ levelScene: WPTLevelScene) {
        self.levelScene = levelScene
        self.player = levelScene.player
        super.init()
        self.zPosition = WPTZPositions.touchHandler
        self.isUserInteractionEnabled = true
        
        let handler = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: levelScene.level.size))
        if WPTConfig.values.showTouchHandler {
            handler.fillColor = UIColor(colorLiteralRed: 1, green: 0, blue: 0, alpha: 0.3)
        }
        self.addChild(handler)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let sceneLoc = touch.location(in: levelScene)
        
        // a touch on the player
        if levelScene.player.contains(sceneLoc) {
            levelScene.player.touched()
            return
        }
            
        // a touch on an enemy?
        for enemy in levelScene.terrain.enemies {
            if enemy.contains(sceneLoc) {
                levelScene.player.aimAt(actor: enemy)
                return 
            }
        }
            
        // face an arbitrary point
        player.facePoint(touch.location(in: self))
    }
}
