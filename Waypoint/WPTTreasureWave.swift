//
//  WPTTreasureWave.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTreasureWave: WPTLevelWave {
    
    static let totalTimeTime = 61 // 1 minute
    
    let treasureChest: WPTFinalTreasureNode = WPTFinalTreasureNode()
    var player: WPTLevelPlayerNode? = nil
    var timer: WPTTreasureTimerNode? = nil
    
    private var scene: WPTLevelScene? = nil
    
    private var coinFrames: Int = 100
    private var treasureCollectingTime: TimeInterval = TimeInterval(WPTTreasureWave.totalTimeTime)
    private var lastShownTime: Int = WPTTreasureWave.totalTimeTime
    
    init() {
        super.init([:])
    }
    
    override func setup(scene: WPTLevelScene) {
        self.scene = scene
        scene.alert(header: "Shiver Me Timbers!", desc: "Collect the treasure!")
        
        treasureChest.position = scene.level.xMarksTheSpot!
        treasureChest.removeFromParent()
        scene.terrain.addChild(treasureChest)
        
        player = scene.player
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        // determine if the level is complete
        return treasureCollectingTime <= 0
    }
    
    override func update(_ deltaTime: TimeInterval) {
        // the treasure will be closed for a bit
        if treasureChest.closed {
            if let player = self.player {
                let dist = CGVector(start: treasureChest.position, end: player.position).magnitude()
                print("the distance: \(dist)")
                if dist < treasureChest.activationDistance {
                    treasureChest.open()
                }
            }
        }
        
        // then when it opens, we make coins for a while
        else if coinFrames > 0 {
            makeCoinSet()
        }
        
        // after the coins are made, we have a timer!
        else {
            if lastShownTime - Int(treasureCollectingTime) > 0 {
                lastShownTime = Int(treasureCollectingTime)
                
                let otherColors = min(CGFloat(6 * lastShownTime) / CGFloat(WPTTreasureWave.totalTimeTime), 1)
                self.timer!.time.fontColor = UIColor(red: 1, green: otherColors, blue: otherColors, alpha: 1)
                self.timer!.show(timeVal: String(lastShownTime))
            }
            treasureCollectingTime -= deltaTime
        }
    }
    
    private func makeCoinSet() {
        guard let scene = self.scene else { return }
        
        for _ in 0..<10 {
            let target = scene.terrain.randomPoint(borderWidth: 0, onLand: false)
            let moneyNode = WPTItemNode(WPTItemCatalog.randomCurrency())
            moneyNode.zPosition = treasureChest.zPosition + 1
            moneyNode.position = treasureChest.position
            
            let move = SKAction.move(to: target, duration: 2)
            moneyNode.run(move)
            scene.items.addChild(moneyNode)
        }
        coinFrames -= 1
        
        // start the timer!!!
        if coinFrames <= 0 {
            self.timer = WPTTreasureTimerNode()
            self.timer!.zPosition = WPTValues.movementHandlerZPosition - 5
            self.timer?.position.y += 0.25 * WPTValues.screenSize.height
            scene.camera!.addChild(timer!)
            self.timer!.show(timeVal: String(20))
        }
    }
    
    override func teardown(scene: WPTLevelScene) -> Bool {
        scene.levelPaused = true
        
        let shroud = SKShapeNode(rectOf: WPTValues.screenSize)
        shroud.fillColor = .black
        shroud.alpha = 0
        shroud.zPosition = 2 * WPTValues.pauseShroudZPosition
        scene.camera!.addChild(shroud)
        
        let fadeIn = SKAction.fadeIn(withDuration: 8)
        let wait = SKAction.wait(forDuration: 3)
        shroud.run(SKAction.sequence([fadeIn, wait])) {
            let storage = WPTStorage()
            
            // submit the score
            let loot = WPTLootSummary(player: scene.player.player)
            storage.submitScore(loot)
            
            // clear the progress
            storage.clearPlayerProgress()
            
            // go to high scores scene
            let transition = SKTransition.fade(withDuration: 1.5)
            scene.view!.presentScene(WPTHighScoresScene(), transition: transition)
        }
        
        return false
    }
}
