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
        super.init(actor: player, teamBitMask: WPTValues.playerTbm)
        self.isUserInteractionEnabled = true
        self.zPosition = WPTValues.movementHandlerZPosition + 1
        
        currentHealth = player.progress.currentHealth ?? player.ship.health
        
        // components
        portHandler = WPTPortDockingHandler(self)
        self.addChild(self.portHandler)
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
    
    
}
