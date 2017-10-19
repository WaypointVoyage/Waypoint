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
    
    private var treasureGone: Bool = false
    
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
        self.scene.player.physics?.velocity = CGVector.zero
        
        // move the camera to the treasure chest
        self.scene.setCameraPosition(self.scene.level.xMarksTheSpot!, duration: 1.5, then: then)
    }
    
    private func playAnimation(then: @escaping () -> Void) {
        
        // TODO: make the animation of tentacles stealing the chest
        
        then()
    }
    
    private func recoverFromAnimation() {
        self.scene.setCameraPosition(self.scene.player.position, duration: 1.5) {
            // remove this treasure chest from the scene
            let treasure = self.scene.terrain.childNode(withName: WPTFinalTreasureNode.TREASURE_NODE_NAME)!
            treasure.removeFromParent()
            self.treasureGone = true
            
            // give the player their controls back
            self.scene.player.setUserInteraction(true)
        }
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        return self.treasureGone
    }
}

