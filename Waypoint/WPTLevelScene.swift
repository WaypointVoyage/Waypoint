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
        
        self.loadLevel()
        
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
    
    private func placeBoulder(_ boulder: WPTBoulderNode) {
        boulder.position = self.terrain.randomPoint(borderWidth: WPTBoulderNode.boulderRadius)
        
        let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        boulder.boulderImage.zRotation = CGFloat(M_PI)/rand
        boulder.crackedImage.zRotation = CGFloat(M_PI)/rand
    }
    
    private func placeWhirlpool(_ whirlpool: WPTWhirlpoolNode) {
        let whirlpools = self.level.whirlpoolLocations
        let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let index = CGFloat(whirlpools.count - 1) * rand
        whirlpool.position = CGPoint(x: whirlpools[Int(index)].x * 2, y: whirlpools[Int(index)].y * 2)
    }
    
    private func loadEnemies() {
        /* TEMPORARY */
        
        // marooner
        let enemy = WPTEnemyCatalog.enemiesByName["Marooner"]!
        let marooner = WPTLevelEnemyNode(enemy: enemy, player: self.player)
        marooner.position = terrain.randomPoint(borderWidth: marooner.sprite.size.width / 2.0, onLand: false)
        self.enemies.append(marooner)
        self.terrain.addEnemy(marooner)
        
        // catapult
//        var enemy = WPTEnemyCatalog.enemiesByName["Catapult"]!
//        let catapult = WPTLevelEnemyNode(enemy: enemy, player: self.player)
//        var onLand: Bool? = enemy.terrainType == WPTEnemyTerrainType.sea ? false : enemy.terrainType == WPTEnemyTerrainType.land ? true : nil
//        var point = self.terrain.randomPoint(borderWidth: catapult.sprite.size.width / 2.0, onLand: onLand)
//        catapult.position = point
//        self.enemies.append(catapult)
//        self.terrain.addEnemy(catapult)
//        
//        // pirate
//        enemy = WPTEnemyCatalog.enemiesByName["Pirate"]!
//        let pirate = WPTLevelEnemyNode(enemy: enemy, player: self.player)
//        onLand = enemy.terrainType == WPTEnemyTerrainType.sea ? false : enemy.terrainType == WPTEnemyTerrainType.land ? true : nil
//        point = self.terrain.randomPoint(borderWidth: pirate.sprite.size.width / 2.0, onLand: onLand)
//        pirate.position = point
//        self.enemies.append(pirate)
//        self.terrain.addEnemy(pirate)
        
        // items
//        for item in WPTItemCatalog.statModifierItems {
//            let itemNode = WPTItemNode(item)
//            itemNode.position = terrain.randomPoint(borderWidth: 0, onLand: false)
//            self.items.addChild(itemNode)
//        }
        
        // cannon
//        let cannonItem = WPTItemCatalog.itemsByName["Cannon"]!
//        let cannonNode = WPTItemNode(cannonItem)
//        cannonNode.position = terrain.randomPoint(borderWidth: 0, onLand: false)
//        self.items.addChild(cannonNode)
    }
    
    private func loadLevel() {
        // setup the player
        self.player.name = WPTLevelScene.playerNameTag
        self.player.position = self.terrain.spawnPoint
        self.terrain.addChild(self.player)
        
        // place whirlpools
        for _ in 0..<self.level.whirlpools {
            let whirlpool = WPTWhirlpoolNode()
            placeWhirlpool(whirlpool)
            self.terrain.addChild(whirlpool)
        }
        
        // place boulders
        for _ in 0..<self.level.boulders {
            let boulder = WPTBoulderNode()
            placeBoulder(boulder)
            self.terrain.addChild(boulder)
        }
        
        // setup the port
        if let port = self.port {
            self.addChild(port)
        }
        
        // load enemies
        loadEnemies()
        
        // add everything to the scene
        self.addChild(projectiles)
        self.addChild(items)
        self.addChild(self.terrain)
    }
    
    private var lastCurrentTime: TimeInterval? = nil
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = lastCurrentTime == nil ? 0 : currentTime - lastCurrentTime!
        lastCurrentTime = currentTime

        if self.levelPaused { return } // everything below this is subject to the pause
        
        self.player.update(currentTime, deltaTime)
        for enemy in self.enemies {
            enemy.update(currentTime, deltaTime)
        }
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
