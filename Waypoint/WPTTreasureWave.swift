//
//  WPTTreasureWave.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTreasureWave: WPTLevelWave {
    
    let treasureChest: WPTFinalTreasureNode = WPTFinalTreasureNode()
    var player: WPTLevelPlayerNode? = nil
    
    private var scene: WPTLevelScene? = nil
    
    private var coinFrames: Int = 100
    
    init() {
        super.init([:])
    }
    
    override func setup(scene: WPTLevelScene) {
        self.scene = scene
        
        treasureChest.position = scene.level.xMarksTheSpot!
        treasureChest.removeFromParent()
        scene.terrain.addChild(treasureChest)
        
        player = scene.player
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        // determine if the level is complete
        return coinFrames == 0
    }
    
    override func update(_ deltaTime: TimeInterval) {
        // treasure!
        if treasureChest.closed {
            if let player = self.player {
                let dist = CGVector(start: treasureChest.position, end: player.position).magnitude()
                print("the distance: \(dist)")
                if dist < treasureChest.activationDistance {
                    treasureChest.open()
                }
            }
        } else if coinFrames > 0 {
            makeCoinSet()
        }
    }
    
    private func makeCoinSet() {
        guard let scene = self.scene else { return }
        
        for _ in 0..<5 {
            let target = scene.terrain.randomPoint(borderWidth: 0, onLand: false)
            let moneyNode = WPTItemNode(WPTItemCatalog.randomCurrency())
            moneyNode.position = treasureChest.position
            
            let move = SKAction.move(to: target, duration: 2)
            moneyNode.run(move)
            scene.items.addChild(moneyNode)
        }
        coinFrames -= 1
    }
}
