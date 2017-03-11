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
    let backgroundMusic = SKAudioNode(fileNamed: "windWaker.mp3")
    
    init(player: WPTLevelPlayerNode, terrain: WPTTerrainNode) {
        self.player = player
        self.top = WPTHudTopNode(player: player.player)
        self.bottom = WPTHudBottomNode()
        self.pauseShroud = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: WPTValues.screenSize))
        self.pauseMenu = WPTPauseMenuNode(terrain: terrain)
        self.destroyMenu = WPTDestroyMenuNode(player: player.player)
        super.init()
        self.isUserInteractionEnabled = true
        
        // top/bottom nodes
        self.addChild(top)
        self.bottom.onStartPress = player.fireCannons
        self.addChild(bottom)
        
        // shroud
        self.pauseShroud.fillColor = UIColor.black
        self.pauseShroud.strokeColor = UIColor.black
        self.pauseShroud.zPosition = WPTValues.pauseShroudZPosition
        self.pauseShroud.alpha = 0.6
        
        // pause menu
        self.pauseMenu.zPosition = WPTValues.pauseShroudZPosition + 1
        self.pauseMenu.position = CGPoint(x: WPTValues.screenSize.width / 2.0, y: WPTValues.screenSize.height / 2.0)
        
        // destroy menu
        self.destroyMenu.zPosition = WPTValues.pauseShroudZPosition + 1
        self.destroyMenu.position = CGPoint(x: WPTValues.screenSize.width / 2.0, y: WPTValues.screenSize.height / 2.0)
        
        //audio
        self.scene?.listener = player
        backgroundMusic.isPositional = false
        backgroundMusic.position = CGPoint(x: self.player.position.x, y: self.player.position.y)
        backgroundMusic.autoplayLooped = true
        self.addChild(backgroundMusic)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        self.top.update(currentTime, deltaTime)
        self.backgroundMusic.position = CGPoint(x: self.player.position.x, y: self.player.position.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchPos = touch.location(in: self)
        var paused = false
        let scene = self.scene as? WPTLevelScene
        if scene != nil {
            paused = scene!.levelPaused
        }
        
        if paused && self.destroyMenu.parent == nil {
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
            backgroundMusic.run(SKAction.pause())
            self.addChild(self.pauseShroud)
            self.addChild(self.pauseMenu)
        } else {
            backgroundMusic.run(SKAction.play())
            self.pauseShroud.removeFromParent()
            self.pauseMenu.removeFromParent()
        }
    }
    
    func processShipHealthStatus(_ healthPoints: CGFloat) {
        let scene = self.scene as? WPTLevelScene
        let alive = self.top.shipHealth.updateHealth(healthPoints)
        if (!alive) {
            scene!.contactDelegate = nil
            scene!.levelPaused = true
            self.top.pause.isHidden = true
            self.bottom.hideBorder()
            self.addChild(self.pauseShroud)
            self.addChild(self.destroyMenu)
        }
    }
    
    func addAudioNode() {
        
        let backgroundMusic = SKAudioNode(fileNamed: "distance.m4a")
        backgroundMusic.isPositional = false
        
        self.addChild(backgroundMusic)
    }
}

