//
//  WPTConfig.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTConfig {
    
    var playMusic = true
    var playSoundEffects = true
    var testing = false
    var allUnlocked = false
    var invincible = true
    var showBrainRadii = false
    var showPhysics = false
    var showSpawnVolumesOnMinimap = false
    var clearHighScoresOnLoad = false
    var showTutorial = true
    
    // singleton instance
    static let values: WPTConfig = {
        let instance = WPTConfig()
        
        return instance
    }()
}
