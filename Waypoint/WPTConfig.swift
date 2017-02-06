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
    
    // singleton instance
    static let values: WPTConfig = {
        let instance = WPTConfig()
        
        return instance
    }()
}
