//
//  WPTPortDockingHandler.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/10/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPortDockingHandler: SKNode {
    public static let nodeName: String = "_PORT_DOCKING_HANDLER"
    private static let portDelay = SKAction.wait(forDuration: 5)
    
    weak var actor: WPTLevelActorNode!
    
    private var port: WPTPortNode? = nil
    var docked: Bool { return port != nil }
    public private(set) var dockPos: CGPoint? = nil
    var canDock = true
    
    init(_ actor: WPTLevelActorNode) {
        self.actor = actor
        super.init()
        self.name = WPTPortDockingHandler.nodeName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dockAt(dock: WPTDockNode) {
        self.port = dock.port
        self.actor.anchored = true
        self.canDock = false
        self.actor.targetRot = nil
        
        let theDockPos = self.scene!.convert(dock.position, from: self.port!)
        let position = SKAction.move(to: theDockPos, duration: 1)
        let rotation = SKAction.rotate(toAngle: dock.rotation, duration: 1)
        self.actor.run(position) {
            self.dockPos = theDockPos
            if let hud = (self.scene as? WPTLevelScene)?.hud {
                hud.dockMenu.updateDoubloons()
                hud.dockMenu.updateStats(item: (hud.dockMenu.itemPicker?.currentItem)!)
                hud.addChild(hud.dockMenu)
                hud.bottom.anchor.startPress()
            }
        }
        self.actor.run(rotation)
    }
    
    func undock() {
        self.port = nil
        self.actor.anchored = false
        self.dockPos = nil
    }
    
    func leaveDock() {
        self.run(WPTPortDockingHandler.portDelay) {
            self.canDock = true
        }
    }
}
