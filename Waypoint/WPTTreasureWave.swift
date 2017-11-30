//
//  WPTTreasureWave.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 7 in the final boss
class WPTTreasureWave: WPTLevelWave {
    
    static let totalTimeTime = 61 // 1 minute
    var timer: WPTTreasureTimerNode? = nil
    
    private var coinFrames: Int = 100
    private var treasureCollectingTime: TimeInterval = TimeInterval(WPTTreasureWave.totalTimeTime)
    private var lastShownTime: Int = WPTTreasureWave.totalTimeTime
    
    private var treasureChest: WPTFinalTreasureNode {
        return self.scene.terrain.childNode(withName: WPTFinalTreasureNode.TREASURE_NODE_NAME) as! WPTFinalTreasureNode
    }
    
    override init(_ waveDict: [String:AnyObject]) {
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        WPTAudioConfig.audio.playSong(song: "waypoint_victory.wav", numLoops: 0, completion: { (true) in
            WPTAudioConfig.audio.playSong(song: "level_map_theme.wav")
        })
        scene.alert(header: "Shiver Me Timbers!", desc: "Collect the treasure!")
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        // determine if the level is complete
        return treasureCollectingTime <= 0
    }
    
    override func update(_ deltaTime: TimeInterval) {
        // the treasure will be closed for a bit
        if treasureChest.closed {
            let dist = CGVector(start: treasureChest.position, end: self.scene.player.position).magnitude()
            if dist < treasureChest.activationDistance {
                treasureChest.open()
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
        guard let theScene = self.scene else { return }
        
        for _ in 0..<10 {
            let target = theScene.terrain.randomPoint(borderWidth: 0, onLand: false)
            let moneyNode = WPTItemNode(WPTItemCatalog.randomCurrency())
            moneyNode.zPosition = treasureChest.zPosition + 1
            moneyNode.position = treasureChest.position
            
            let hold = moneyNode.physicsBody
            moneyNode.physicsBody = nil
            let move = SKAction.move(to: target, duration: 2) 
            moneyNode.run(move) {
                moneyNode.physicsBody = hold
            }
            theScene.items.addChild(moneyNode)
        }
        coinFrames -= 1
        
        // start the timer!!!
        if coinFrames <= 0 {
            self.timer = WPTTreasureTimerNode()
            self.timer?.position.y += 0.25 * WPTValues.screenSize.height
            theScene.camera!.addChild(timer!)
            self.timer!.show(timeVal: String(20))
        }
    }
    
    override func teardown(scene: WPTLevelScene) -> Bool {
        self.scene.player.anchored = true
        self.scene.player.setUserInteraction(false)
        self.scene.player.physicsBody?.velocity = CGVector.zero
        
        let shroud = SKShapeNode(rectOf: WPTValues.screenSize)
        shroud.fillColor = .black
        shroud.alpha = 0
        shroud.zPosition = 2 * WPTZPositions.shrouds
        scene.camera!.addChild(shroud)
        
        NSLog("Done! Now fading out")
        let fadeIn = SKAction.fadeIn(withDuration: 5)
        let wait = SKAction.wait(forDuration: 2)
        shroud.run(SKAction.sequence([fadeIn, wait])) {
            NSLog("Going to high scored page")
            let storage = WPTStorage()
            
            // submit the score
            let loot = WPTLootSummary(player: scene.player)
            storage.submitScore(loot)
            
            // clear the progress
            storage.clearPlayerProgress()
            
            // go to high scores scene
            let transition = SKTransition.fade(withDuration: 1.5)
            let highScores = WPTHighScoresScene()
            highScores.song = "level_map_theme.wav"
            scene.view!.presentScene(highScores, transition: transition)
        }
        
        return false
    }
}
