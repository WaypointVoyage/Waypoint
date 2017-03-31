//
//  WPTPlayerMovementTouchHandler.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/25/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelTouchHandlerNode: SKNode, WPTUpdatable {
    
    private let player: WPTLevelPlayerNode
    private let levelScene: WPTLevelScene
    
    private var moveTouch: UITouch? = nil
    
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
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        if let moveTouch = self.moveTouch {
            player.facePoint(moveTouch.location(in: self))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let sceneLoc = touch.location(in: levelScene)
        
        // a touch on the player
        let playerLoc = touch.location(in: levelScene.player)
        if levelScene.player.sprite.contains(playerLoc) {
            levelScene.player.touched()
            return
        }
            
        // a touch on an enemy?
        for enemy in levelScene.terrain.enemies {
            let enemyLoc = touch.location(in: enemy)
            if enemy.sprite.contains(enemyLoc) {
                levelScene.player.aimAt(node: enemy)
                return
            }
        }
        
        // perhaps a rock?
        for boulder in levelScene.terrain.children.filter({ $0.name == WPTBoulderNode.nodeNameTag }) {
            if boulder.contains(sceneLoc) {
                levelScene.player.aimAt(node: boulder)
                return
            }
        }
            
        // I guess the enemy has a new target point then
        moveTouch = touch
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if self.moveTouch === touch {
            self.moveTouch = nil
        }
    }
}
