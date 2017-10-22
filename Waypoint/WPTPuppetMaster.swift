//
//  WPTPuppetMaster.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTPuppetMaster: GKStateMachine {
    weak var scene: WPTLevelScene!
    
    init(_ scene: WPTLevelScene) {
        self.scene = scene
        super.init(states: [
            WPTPlayerPrepPMS(), WPTWaveCreationPMS(), WPTWaveExecutionPMS(), WPTLevelBeatenPMS()
        ])
    }
    
    func setStage(levelBeaten: Bool) {
        if !enter(levelBeaten ? WPTLevelBeatenPMS.self : WPTPlayerPrepPMS.self) {
            NSLog("ERROR: Could not start WPTPuppetMaster!")
            return
        }
        
        // place boulders
        if !self.scene.levelBeaten {
            for _ in 0..<self.scene.level.boulders {
                let boulder = WPTBoulderNode()
                placeBoulder(boulder)
                self.scene.terrain.addChild(boulder)
            }
        }
    }
    
    private func placeBoulder(_ boulder: WPTBoulderNode) {
        boulder.position = self.scene.terrain.randomPoint(borderWidth: WPTBoulderNode.boulderRadius, onLand: false)
        
        let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        boulder.boulderImage.zRotation = CG_PI/rand
        boulder.crackedImage.zRotation = CG_PI/rand
    }
    
    override func update(deltaTime sec: TimeInterval) {
        super.update(deltaTime: sec)
        
        if let period = self.scene.level.whirlpoolPeriod {
            let rand = randomNumber(min: 0, max: CGFloat(period))
            if rand < CGFloat(sec) {
                let whirlpool = WPTWhirlpoolNode()
                whirlpool.position = self.scene.terrain.randomPoint(borderWidth: WPTWhirlpoolNode.whirlpoolRadius, onLand: false)
                self.scene.terrain.addChild(whirlpool)
                whirlpool.start()
            }
        }
    }
}
