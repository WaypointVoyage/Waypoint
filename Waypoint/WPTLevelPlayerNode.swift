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
        self.port = dock.port
        self.physicsBody!.isDynamic = false
        self.anchored = true
        self.canDock = false
        
        let dockPos = self.scene!.convert(dock.position, from: self.port!)
        let position = SKAction.move(to: dockPos, duration: 1)
        let rotation = SKAction.rotate(toAngle: (port?.zRotation)!, duration: 1)
        self.run(position)
        self.run(rotation)
    }
    
    func undock() {
        self.port = nil
        self.physicsBody!.isDynamic = true
        self.anchored = false
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        guard !docked else { return }
        super.update(currentTime, deltaTime)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if docked {
            self.undock()
        } else {
            self.anchored = !self.anchored
        }
        
    }
    
}
