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
        
        if ((firstBody.categoryBitMask & WPTValues.projectileCbm) != 0 && (secondBody.categoryBitMask & WPTValues.boulderCbm) != 0) {
            if let cannonBall = firstBody.node as? WPTCannonBallNode,
                let boulder = secondBody.node as? WPTBoulderNode {
                cannonBall.removeFromParent()
                boulder.processHealthStatus(-20.0)
            }
        } else if ((firstBody.categoryBitMask & WPTValues.actorCbm) != 0 && (secondBody.categoryBitMask & WPTValues.itemCbm) != 0) {
            if let player = firstBody.node as? WPTLevelActorNode,
                let item = secondBody.node as? WPTItemNode {
                if (item.tier.rawValue == "CURRENCY") {
                    player.actor.doubloons += item.value
                    self.scene.hud.top.updateMoney()
                    item.removeFromParent()
                }
            }
        } else if ((firstBody.categoryBitMask & WPTValues.actorCbm) != 0 && (secondBody.categoryBitMask & WPTValues.whirlpoolCbm) != 0) {
            if let player = firstBody.node as? WPTLevelActorNode,
                let _ = secondBody.node as? WPTWhirlpoolNode {
                let oldPosition = player.position
                player.position = CGPoint(x: oldPosition.x - 50, y: oldPosition.y - 50)
                let oneRevolution = SKAction.rotate(byAngle: -.pi * 2, duration: 1.0)
                player.run(oneRevolution)
                self.scene.hud.processShipHealthStatus(-5)
            }
        }
        else if firstBody.categoryBitMask & WPTValues.actorCbm != 0 && secondBody.categoryBitMask & WPTValues.dockCbm != 0 {
            if let player = firstBody.node as? WPTLevelPlayerNode {
                if !player.docked && player.canDock {
                    if let dock = secondBody.node as? WPTDockNode {
                        player.dockAt(dock: dock)
                    }
                }
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        setContacts(contact)
        
        if firstBody.categoryBitMask & WPTValues.actorCbm != 0 && secondBody.categoryBitMask & WPTValues.dockCbm != 0 {
            if let player = firstBody.node as? WPTLevelPlayerNode {
                if let _ = secondBody.node as? WPTDockNode {
                    player.run(SKAction.wait(forDuration: 3)) {
                        player.canDock = true
                    }
                }
            }
        }
    }
    
}
