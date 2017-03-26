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
    var testing = true
    var allUnlocked = true
    var invincible = true
    var showBrainRadii = false // kinda buggy, use with caution... need to address this. 
    var showPhysics = false
    var showSpawnVolumesOnMinimap = false
    var clearHighScoresOnLoad = false
    var showTutorial = false
    
    // singleton instance
    static let values: WPTConfig = {
        let instance = WPTConfig()
        
        return instance
    }()
}
