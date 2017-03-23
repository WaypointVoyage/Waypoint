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
        
        // place whirlpools
        for _ in 0..<self.scene.level.whirlpools {
            let whirlpool = WPTWhirlpoolNode()
            placeWhirlpool(whirlpool)
            self.scene.terrain.addChild(whirlpool)
        }
        
        // place boulders
        for _ in 0..<self.scene.level.boulders {
            let boulder = WPTBoulderNode()
            placeBoulder(boulder)
            self.scene.terrain.addChild(boulder)
        }
    }
    
    private func placeBoulder(_ boulder: WPTBoulderNode) {
        boulder.position = self.scene.terrain.randomPoint(borderWidth: WPTBoulderNode.boulderRadius)
        
        let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        boulder.boulderImage.zRotation = CGFloat(M_PI)/rand
        boulder.crackedImage.zRotation = CGFloat(M_PI)/rand
    }
    
    private func placeWhirlpool(_ whirlpool: WPTWhirlpoolNode) {
//        let whirlpools = self.scene.level.whirlpoolLocations
//        let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
//        let index = CGFloat(whirlpools.count - 1) * rand
//        whirlpool.position = CGPoint(x: whirlpools[Int(index)].x * 2, y: whirlpools[Int(index)].y * 2)
        whirlpool.position = scene.terrain.randomPoint(borderWidth: WPTWhirlpoolNode.whirlpoolRadius, onLand: false)
    }
}
