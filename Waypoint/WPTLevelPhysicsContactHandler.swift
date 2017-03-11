//
//  WPTLevelPhysicsContactHandler.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelPhysicsContactHandler: NSObject, SKPhysicsContactDelegate {
    let scene: WPTLevelScene
    
    private var firstBody: SKPhysicsBody! = nil
    private var secondBody: SKPhysicsBody! = nil
    
    init(_ scene: WPTLevelScene) {
        self.scene = scene
    }
    
    private func setContacts(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        setContacts(contact)
        
        if collisionBetween(WPTValues.projectileCbm, WPTValues.boulderCbm) {
            if let cannonBall = firstBody.node as? WPTCannonBallNode,
                let boulder = secondBody.node as? WPTBoulderNode {
                cannonBall.removeFromParent()
                boulder.processHealthStatus(-20.0)
            }
        } else if collisionBetween(WPTValues.actorCbm, WPTValues.itemCbm) {
            if let player = firstBody.node as? WPTLevelActorNode,
                let item = secondBody.node as? WPTItemNode {
                if (item.tier.rawValue == "CURRENCY") {
                    player.actor.doubloons += item.value
                    self.scene.hud.top.updateMoney()
                    self.scene.hud.destroyMenu.updateMoney()
                    item.removeFromParent()
                }
            }
        } else if collisionBetween(WPTValues.actorCbm, WPTValues.whirlpoolCbm) {
            if let actor = firstBody.node as? WPTLevelActorNode, let _ = secondBody.node as? WPTWhirlpoolNode {
                if let whirlpoolHandler = actor.childNode(withName: WPTWhirlpoolHandler.nodeName) as? WPTWhirlpoolHandler {
                    if whirlpoolHandler.canEnterWhirlpool {
                        whirlpoolHandler.enterWhirlpool()
                    }
                }
            }
        }
        else if collisionBetween(WPTValues.actorCbm, WPTValues.dockCbm) {
            if let player = firstBody.node as? WPTLevelPlayerNode {
                if let dockHandler = player.childNode(withName: WPTPortDockingHandler.nodeName) as? WPTPortDockingHandler {
                    if !dockHandler.docked && dockHandler.canDock {
                        if let dock = secondBody.node as? WPTDockNode {
                            dockHandler.dockAt(dock: dock)
                        }
                    }
                }
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        setContacts(contact)
        
        if collisionBetween(WPTValues.actorCbm, WPTValues.whirlpoolCbm) {
            if let whirlpoolHanlder = (firstBody.node as? WPTLevelActorNode)?.childNode(withName: WPTWhirlpoolHandler.nodeName) as? WPTWhirlpoolHandler, let _ = secondBody.node as? WPTWhirlpoolNode {
                whirlpoolHanlder.exitWhirlpool()
            }
        }
        else if collisionBetween(WPTValues.actorCbm, WPTValues.dockCbm) {
            if let dockHandler = (firstBody.node as? WPTLevelPlayerNode)?.childNode(withName: WPTPortDockingHandler.nodeName) as? WPTPortDockingHandler, let _ = secondBody.node as? WPTDockNode {
                dockHandler.leaveDock()
            }
        }
    }
    
    private func collisionBetween(_ first: UInt32, _ second: UInt32) -> Bool {
        return firstBody.categoryBitMask & first != 0 && secondBody.categoryBitMask & second != 0
    }
}
