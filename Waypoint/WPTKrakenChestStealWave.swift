//
//  WPTKrakenChestStealWave.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 2 in the final boss
class WPTKrakenChestStealWave: WPTLevelWave {

    private var treasureGone = false
    
    override init(_ waveDict: [String:AnyObject]) {
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        
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
        self.scene.setCameraPosition(self.scene.level.xMarksTheSpot!, duration: 1.5, then: then)
    }
    
    private func playAnimation(then: @escaping () -> Void) {
        
        // calculate the tentacle spawn location
        let delta = CGVector(start: self.scene.player.position, end: self.scene.level.xMarksTheSpot!)
        let tentaclePos = self.scene.level.xMarksTheSpot! + 1.14 * delta
        
        // make the tentacle
        let tentacle = WPTLevelTentacleNode(type: WPTTentacleEnemyType.STATIC_TENTACLE, player: self.scene.player, submerged: true)
        tentacle.zRotation = CGVector(start: tentaclePos, end: self.scene.level.xMarksTheSpot!).angle()
        tentacle.position = tentaclePos
        self.scene.terrain.addEnemy(tentacle)
        
        // grab the chest
        tentacle.surface(duration: 3.0) {
            tentacle.run(SKAction.wait(forDuration: 0.5)) {
                let submergeTime: TimeInterval = 0.3
                
                let chest = self.scene.terrain.childNode(withName: WPTFinalTreasureNode.TREASURE_NODE_NAME)!
                chest.run(SKAction.move(to: tentaclePos, duration: submergeTime)) {
                    chest.removeFromParent()
                }
                
                tentacle.submerge(duration: submergeTime) {
                    self.scene.terrain.removeEnemy(tentacle)
                    then()
                }
            }
        }
    }
    
    private func recoverFromAnimation() {
        self.scene.setCameraPosition(self.scene.player.position, duration: 1.5) {
            self.treasureGone = true
            
            // give the player their controls back
            self.scene.player.setUserInteraction(true)
            self.scene.setCameraPosition(duration: 0)
        }
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        return self.treasureGone
    }
}

