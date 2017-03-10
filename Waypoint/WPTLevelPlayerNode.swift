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
    private var port: WPTPortNode? = nil
    var docked: Bool { return port != nil }
    private var dockPos: CGPoint? = nil
    var canDock = true
    
    init(player: WPTPlayer) {
        super.init(actor: player)
        self.isUserInteractionEnabled = true
        self.zPosition = WPTValues.movementHandlerZPosition + 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dockAt(dock: WPTDockNode) {
        // update state
        self.port = dock.port
        self.anchored = true
        self.canDock = false
        self.targetRot = nil
        
        let theDockPos = self.scene!.convert(dock.position, from: self.port!)
        let position = SKAction.move(to: theDockPos, duration: 1)
        let rotation = SKAction.rotate(toAngle: (port?.zRotation)!, duration: 1)
        self.run(position) {
            self.dockPos = theDockPos
        }
        self.run(rotation)
    }
    
    func undock() {
        self.port = nil
        self.anchored = false
        self.dockPos = nil
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        if !docked {
            super.update(currentTime, deltaTime)
        } else if let dockPos = dockPos {
            self.position = dockPos
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if docked {
            self.undock()
        } else {
            self.anchored = !self.anchored
        }
    }
    
}
