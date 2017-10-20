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
    
    let reticle = WPTReticleNode()
    var itemRad: WPTItemCollectorNode! = nil
    
    public private(set) var interactionEnabled: Bool = true
    
    override var spriteImage: String {
        return self.actor.ship.inGamePlayerImage!
    }
    
    init(player: WPTPlayer) {
        super.init(actor: player, teamBitMask: WPTConfig.values.testing ? 0 : WPTValues.playerTbm)
        
        currentHealth = player.health
        
        // components
        portHandler = WPTPortDockingHandler(self)
        self.addChild(self.portHandler)
        
        // item collection radius
        itemRad = WPTItemCollectorNode(target: self, radius: player.ship.itemRadius)
        itemRad.setScale(1 / player.ship.size)
        self.addChild(itemRad)
        
        self.physicsBody!.collisionBitMask |= WPTValues.boundaryCbm
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        if let targetNode = self.targetNode {
            self.aimCannons(node: targetNode)
        } else if reticle.attached {
            self.reticle.remove()
        }
        
        if reticle.attached {
            reticle.update(currentTime, deltaTime)
        }
        
        itemRad.update(currentTime, deltaTime)
        
        if !portHandler.docked {
            super.update(currentTime, deltaTime)
        } else if let dockPos = portHandler.dockPos {
            self.position = dockPos
        }
    }
    
    public func setUserInteraction(_ value: Bool) {
        self.interactionEnabled = value
        if let scene = self.scene as? WPTLevelScene {
            scene.touchHandler.setInteraction(value)
        }
        if value {
            self.fireRateMgr.enable()
        } else {
            self.fireRateMgr.disable()
        }
    }
    
    override func getShipSpeed() -> CGFloat {
        if let moveTouchDist = (self.scene as? WPTLevelScene)?.touchHandler.moveTouchDist {
            var fraction = moveTouchDist / 350 // TODO: make sure this is working ok for different screen sizes
            clamp(&fraction, min: 0.1, max: 1)
            return fraction * player.ship.speed
        }
        
        return player.ship.speed
    }
    
    func touched() {
        if portHandler.docked {
            self.portHandler.undock()
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
                
                OperationQueue().addOperation {
                    let storage = WPTStorage()
                    
                    // clear progress
                    storage.clearPlayerProgress()
                }
            }
        }
    }
    
    override func give(item: WPTItem) {
        super.give(item: item)
        
        // update doubloons at the top
        if let _ = item.doubloons, let top = (self.scene as? WPTLevelScene)?.hud.top {
            top.updateMoney()
        }
        
        // update the health bar
        if let repair = item.repair {
            if item.repairProportionally {
                self.doDamage(repair * self.player.ship.health)
            } else {
                self.doDamage(repair)
            }
        }
        
        // show description
        if let desc = item.description {
            if let scene = self.scene as? WPTLevelScene {
               scene.alert(header: item.name, desc: desc)
            }
        }
    }
    
    override func aimAt(node target: SKNode) {
        super.aimAt(node: target)
        self.reticle.track(node: target)
    }
}
