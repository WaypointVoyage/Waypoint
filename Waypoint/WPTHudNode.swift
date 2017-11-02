//
//  WPTHudNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHudNode: SKNode, WPTUpdatable {
    
    let player: WPTLevelPlayerNode
    let top: WPTHudTopNode
    let bottom: WPTHudBottomNode
    let pauseShroud: SKShapeNode
    let pauseMenu: WPTPauseMenuNode
    let destroyMenu: WPTDestroyMenuNode
    let dockMenu: WPTDockMenuNode
    
    init(player: WPTLevelPlayerNode, terrain: WPTTerrainNode) {
        self.player = player
        self.top = WPTHudTopNode(player: player.player)
        self.bottom = WPTHudBottomNode(leftMode: WPTAudioConfig.audio.getLeftyControls())
        self.pauseShroud = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: WPTValues.screenSize))
        self.pauseMenu = WPTPauseMenuNode(terrain: terrain)
        self.destroyMenu = WPTDestroyMenuNode(player: player.player)
        self.dockMenu = WPTDockMenuNode(player: player, level: terrain.level)
        
        super.init()
        self.isUserInteractionEnabled = true
        self.zPosition = WPTZPositions.hud
        
        // top/bottom nodes
        self.addChild(top)
        self.addChild(bottom)
        
        // shroud
        self.pauseShroud.fillColor = UIColor.black
        self.pauseShroud.strokeColor = UIColor.black
        self.pauseShroud.zPosition = WPTZPositions.shrouds - WPTZPositions.hud
        self.pauseShroud.alpha = 0.6
        
        // pause menu
        self.pauseMenu.zPosition = pauseShroud.zPosition + 1
        self.pauseMenu.position = CGPoint(x: WPTValues.screenSize.width / 2.0, y: WPTValues.screenSize.height / 2.0)
        
        // destroy menu
        self.destroyMenu.zPosition = pauseShroud.zPosition + 1
        self.destroyMenu.position = CGPoint(x: WPTValues.screenSize.width / 2.0, y: WPTValues.screenSize.height / 2.0)
        
        // dock menu
        self.dockMenu.zPosition = pauseShroud.zPosition + 1
        self.dockMenu.position = CGPoint(x: WPTValues.screenSize.width / 2.0, y: WPTValues.screenSize.height / 2.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        self.top.update(currentTime, deltaTime)
        self.bottom.update(currentTime, deltaTime)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchPos = touch.location(in: self)
        var paused = false
        let scene = self.scene as? WPTLevelScene
        if scene != nil {
            paused = scene!.levelPaused
        }
        
        if paused && self.destroyMenu.parent == nil && self.dockMenu.parent == nil {
            if !self.pauseMenu.contains(touchPos) {
                // the background was touched, unpause
                scene?.levelPaused = false
                self.toggleShroud(false)
            }
        } else {
            if self.top.pause.contains(touchPos) {
                scene?.levelPaused = true
                self.toggleShroud(true)
                self.pauseMenu.map.updateActorPositions()
            }
        }
    }
    
    private func toggleShroud(_ isPaused: Bool) {
        if isPaused {
            self.pauseMenu.levelName = (self.scene as! WPTLevelScene).level.name
            self.pauseMenu.cancelConfirmQuit()
            self.top.pause.texture = SKTexture(imageNamed: "pressed_pause")
            WPTAudioConfig.audio.pause()
            self.addChild(self.pauseShroud)
            self.addChild(self.pauseMenu)
        } else {
            WPTAudioConfig.audio.play()
            self.top.pause.texture = SKTexture(imageNamed: "pause")
            self.pauseShroud.removeFromParent()
            self.pauseMenu.removeFromParent()
        }
    }
}

