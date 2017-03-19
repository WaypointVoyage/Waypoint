//
//  WPTLevelScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import AVFoundation

class WPTLevelScene: WPTScene {
    static let levelNameTag = "_LEVEL"
    static let playerNameTag = "_PLAYER"
    
    let level: WPTLevel
    public private(set) var puppetMaster: WPTPuppetMaster? = nil
    
    let terrain: WPTTerrainNode
    let player: WPTLevelPlayerNode
    var hud: WPTHudNode
    var cam: SKCameraNode!
    let projectiles: SKNode
    let items: SKNode
    let port: WPTPortNode?
    var enemies: [WPTLevelEnemyNode] = [WPTLevelEnemyNode]()
    
    var contactDelegate: WPTLevelPhysicsContactHandler! = nil
    
    var levelPaused: Bool = false {
        didSet { self.pauseChanged() }
    }
    
    init(player: WPTPlayer, level: WPTLevel) {
        self.player = WPTLevelPlayerNode(player: player)
        self.level = level
        self.terrain = WPTTerrainNode(level: level, player: self.player)
        self.hud = WPTHudNode(player: self.player, terrain: self.terrain)
        self.projectiles = SKNode()
        self.items = SKNode()
        if let port = level.port {
            self.port = WPTPortNode(port: port)
        } else {
            self.port = nil
        }
        super.init(size: CGSize(width: 0, height: 0))
        self.puppetMaster = WPTPuppetMaster(self)
        
        self.listener = self.player
        self.scene?.backgroundColor = UIColor.black
        
        // setup the physics behavior
        self.physicsWorld.gravity = CGVector.zero
        self.contactDelegate = WPTLevelPhysicsContactHandler(self)
        self.physicsWorld.contactDelegate = self.contactDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // camera
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam)
        cam.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.hud.position = CGPoint(x: -self.cam.frame.midX, y: -self.cam.frame.midY)
        self.cam.setScale(1.0 / WPTValues.levelSceneScale)
        cam.addChild(self.hud)
        
        // setup the port
        if let port = self.port {
            self.addChild(port)
        }
        
        // setup the player
        self.player.name = WPTLevelScene.playerNameTag
        self.player.position = self.terrain.spawnPoint
        self.terrain.addChild(self.player)
        
        // add everything to the scene
        self.addChild(projectiles)
        self.addChild(items)
        self.addChild(self.terrain)
        
        // setup the puppet master
        self.puppetMaster!.setStage(levelBeaten: player.player.progress.completedLevels.contains(level.name))
        
        // breif flash of level name
        let levelName = WPTLabelNode(text: self.level.name, fontSize: WPTValues.fontSizeLarge)
        levelName.name = WPTLevelScene.levelNameTag
        levelName.zPosition = WPTValues.movementHandlerZPosition - 1
        levelName.position.y += 0.2 * WPTValues.screenSize.height
        levelName.alpha = 0
        levelName.fontColor = UIColor.black
        self.cam.addChild(levelName)
        WPTLabelNode.fadeInOut(levelName, 0.5, 2, 2, 2, completion: {
            levelName.removeFromParent()
        })
    }
    
    private var lastCurrentTime: TimeInterval? = nil
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = lastCurrentTime == nil ? 0 : currentTime - lastCurrentTime!
        lastCurrentTime = currentTime

        if self.levelPaused { return } // everything below this is subject to the pause
        
        // puppet master
        self.puppetMaster?.update(deltaTime: deltaTime)
        
        // actors
        self.player.update(currentTime, deltaTime)
        for enemy in self.enemies {
            enemy.update(currentTime, deltaTime)
        }
        
        // HUD
        self.hud.update(currentTime, deltaTime)
    }
    
    override func didSimulatePhysics() {
        // center camera on player while restricting the camera bounds
        var target = self.terrain.position + self.player.position
        
        // restrict vertical direction
        let sceneHeight = self.scene!.size.height * self.cam.yScale
        let top = target.y + sceneHeight / 2.0
        let bottom = top - sceneHeight
        if top > terrain.size.height {
            target.y = terrain.size.height - sceneHeight / 2.0
        } else if bottom < 0 {
            target.y = sceneHeight / 2.0
        }
        
        // restrict horizontal direction
        let sceneWidth = self.scene!.size.width * self.cam.xScale
        let left = target.x - sceneWidth / 2.0
        let right = left + sceneWidth
        if left < 0 {
            target.x = sceneWidth / 2.0
        } else if right > terrain.size.width {
            target.x = terrain.size.width - sceneWidth / 2.0
        }
        
        // apply the camera position
        self.cam.position = target
    }
        
    private func pauseChanged() {
        if let levelName = self.childNode(withName: WPTLevelScene.levelNameTag) {
            levelName.isPaused = self.levelPaused
        }
        self.physicsWorld.speed = self.levelPaused ? 0.0 : 1.0 // pause physics simulation
    }
}
