//
//  WPTConfig.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTConfig {
    
    // audio
    var playMusic = true            // toggle music
    var playSoundEffects = true     // toggle sound effects
    
    // testing
    var testing = true                  // toggles general testing features
    var allUnlocked = true              // determines if all of the levels on the world map are unlocked and beaten
    var invincible = true               // if true, the player is invincible
    var clearHighScoresOnLoad = false   // if true, all of the high scores are cleared when the app is loaded
    var showTutorial = false            // if false, the tutorial will never be shown
    
    // visual debugging
    var showPhysics = false                 // shows physics bodies
    var showBrainRadii = false              // shows the brain radius for each enemy
    var showSpawnVolumesOnMinimap = false   // shows the spawn volume areas as rectangles on the level minimap
    var showTouchHandler = false            // shows a transparent shroud on the touch handler
    
    // singleton instance
    private init() {}
    static let values: WPTConfig = WPTConfig()
}
