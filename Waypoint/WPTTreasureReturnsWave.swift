//
//  WPTTreasureReturnsWave.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 6 in the final boss
class WPTTreasureReturnsWave: WPTLevelWave {
    
    private let treasureChest: WPTFinalTreasureNode = WPTFinalTreasureNode()
    private var treasureBack: Bool = false
    
    override init(_ waveDict: [String:AnyObject]) {
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        WPTAudioConfig.audio.playSong(song: "level_map_theme.wav")
        self.prepareForAnimation {
            self.playAnimation {
                self.recoverFromAnimation()
            }
        }
    }
    
    private func prepareForAnimation(then: @escaping () -> Void) {
        // anchor the player and disable their controls
        self.scene.player.anchored = true
        self.scene.player.setUserInteraction(false)
        self.scene.player.physicsBody?.velocity = CGVector.zero
        
        // move the camera to the treasure chest
        self.scene.setCameraPosition(self.scene.level.xMarksTheSpot!, duration: 2.0, then: then)
    }
    
    private func playAnimation(then: @escaping () -> Void) {
        // calculate the tentacle spawn location
        let delta = CGVector(start: self.scene.player.position, end: self.scene.level.xMarksTheSpot!)
        let tentaclePos = self.scene.level.xMarksTheSpot! + 600 * delta.normalized()
        
        // make the tentacle
        let tentacle = WPTLevelTentacleNode(type: WPTTentacleEnemyType.STATIC_TENTACLE, player: self.scene.player, submerged: true)
        tentacle.zRotation = CGVector(start: tentaclePos, end: self.scene.level.xMarksTheSpot!).angle()
        tentacle.position = tentaclePos
        self.scene.terrain.addEnemy(tentacle)
        
        // put the chest back
        self.treasureChest.removeFromParent()
        self.scene.terrain.addChild(treasureChest)
        self.treasureChest.position = tentaclePos
        let putBackTime: TimeInterval = 3.0
        
        self.treasureChest.run(SKAction.move(to: self.scene.level.xMarksTheSpot!, duration: putBackTime))
        
        tentacle.surface(duration: putBackTime) {
            tentacle.run(SKAction.wait(forDuration: 0.5)) {
                tentacle.submerge(duration: 0.3) {
                    self.scene.terrain.removeEnemy(tentacle)
                    then()
                }
            }
        }
    }
    
    private func recoverFromAnimation() {
        self.scene.setCameraPosition(self.scene.player.position, duration: 2.0) {
            self.treasureBack = true
            
            // give the player their controls back
            self.scene.player.setUserInteraction(true)
            self.scene.setCameraPosition(duration: 0)
        }
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        return self.treasureBack
    }
}
