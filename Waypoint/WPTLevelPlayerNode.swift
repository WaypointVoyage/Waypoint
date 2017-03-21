//
//  WPTLevelPlayerNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelPlayerNode: WPTLevelActorNode {
    
    var player: WPTPlayer { return self.actor as! WPTPlayer }
    var portHandler: WPTPortDockingHandler! = nil
    
    init(player: WPTPlayer) {
        super.init(actor: player, teamBitMask: WPTConfig.values.testing ? 0 : WPTValues.playerTbm)
        self.isUserInteractionEnabled = true
        self.zPosition = WPTValues.movementHandlerZPosition + 1
        
        currentHealth = player.health
        
        // components
        portHandler = WPTPortDockingHandler(self)
        self.addChild(self.portHandler)
        
        self.physics.collisionBitMask |= WPTValues.boundaryCbm
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        if !portHandler.docked {
            super.update(currentTime, deltaTime)
        } else if let dockPos = portHandler.dockPos {
            self.position = dockPos
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if portHandler.docked {
            self.portHandler.undock()
        } else {
            self.anchored = !self.anchored
        }
    }
    
    override func doDamage(_ damage: CGFloat) {
        super.doDamage(damage)
        if let scene = (self.scene as? WPTLevelScene) {
            let alive = scene.hud.top.shipHealth.updateHealth(damage)
            if !alive && !WPTConfig.values.invincible {
                scene.contactDelegate = nil
                scene.levelPaused = true
                scene.hud.top.pause.isHidden = true
                scene.hud.bottom.hideBorder()
                scene.hud.addChild(scene.hud.pauseShroud)
                scene.hud.destroyMenu.updateMoney()
                scene.hud.addChild(scene.hud.destroyMenu)
                
                // delete save data
                let storage = WPTStorage()
                storage.clearPlayerProgress()
            }
        }
    }
}
