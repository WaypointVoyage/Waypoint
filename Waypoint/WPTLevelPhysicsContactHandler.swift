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
                boulder.processHealthStatus(-cannonBall.damage)
            }
        }
            
        else if collisionBetween(WPTValues.actorCbm, WPTValues.projectileCbm) {
            if let actor = firstBody.node as? WPTLevelActorNode, let projectile = secondBody.node as? WPTCannonBallNode {
                if projectile.teamBitMask != actor.teamBitMask {
                    projectile.collide(with: actor);
                }
            }
        }
            
        else if collisionBetween(WPTValues.projectileCbm, WPTValues.damageActorCbm) {
            if let projectile = firstBody.node as? WPTCannonBallNode, let actor = secondBody.node?.parent as? WPTLevelEnemyNode {
                if projectile.teamBitMask != actor.teamBitMask {
                    projectile.collide(with: actor);
                }
            }
        }
            
        else if collisionBetween(WPTValues.itemCbm, WPTValues.itemCollectionCbm) {
            if let itemRad = secondBody.node as? WPTItemCollectorNode, let item = firstBody.node as? WPTItemNode {
                itemRad.collect(item: item)
            }
        }
            
        else if collisionBetween(WPTValues.actorCbm, WPTValues.itemCbm) {
            if let player = firstBody.node as? WPTLevelPlayerNode, let item = secondBody.node as? WPTItemNode {
                player.give(item: item.item);
                item.removeFromParent()
            }
        }
        
        else if collisionBetween(WPTValues.actorCbm, WPTValues.whirlpoolCbm) {
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
                            if (dock.port?.active)! {
                                dockHandler.dockAt(dock: dock)
                            }
                        }
                    }
                }
            }
        }
        
        else if collisionBetween(WPTValues.actorCbm, WPTValues.damageActorCbm) {
            if let player = firstBody.node as? WPTLevelPlayerNode, let enemy = secondBody.node?.parent as? WPTLevelEnemyNode {
                if let whirlpoolHandler = player.childNode(withName: WPTWhirlpoolHandler.nodeName) as? WPTWhirlpoolHandler {
                    whirlpoolHandler.enterWhirlpool(damage: -enemy.actor.ship.damage)
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
        
        else if collisionBetween(WPTValues.actorCbm, WPTValues.damageActorCbm) {
            if let player = firstBody.node as? WPTLevelPlayerNode, let _ = secondBody.node?.parent as? WPTLevelEnemyNode {
                if let whirlpoolHandler = player.childNode(withName: WPTWhirlpoolHandler.nodeName) as? WPTWhirlpoolHandler {
                    whirlpoolHandler.exitWhirlpool()
                }
            }
        }
    }
    
    private func collisionBetween(_ first: UInt32, _ second: UInt32) -> Bool {
        assert(first <= second, "The first collision mask must be less than the second, consider switching their order.")
        return firstBody.categoryBitMask & first != 0 && secondBody.categoryBitMask & second != 0
    }
}
