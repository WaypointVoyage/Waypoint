//
//  WPTConfig.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class WPTConfig {
    
    // mode
    let mode: WPTAppMode = WPTAppMode.LEVEL// Switch value to change the testing mode
                                             // Configuration for individual modes can be found later in this file
                                             // IMPORTANT: keep this set to NORMAL when committing.
    
    let giveRandomItems: Int? = 25          // if not nil, and mode == .LEVEL or .WORLD, this many random items will be given to the player on launch
    let itemsPerCannon: Int? = 5          // for this many items, a single cannon is given when giveRandomItems is being used
    
    // audio
    let playMusic = true            // toggle music
    let playSoundEffects = true     // toggle sound effects
    
    // testing
    var testing = true                  // toggles general testing features
    var allUnlocked = false              // determines if all of the levels on the world map are unlocked and beaten
    var freeItems = false                // if true, all items are free
    var invincible = false               // if true, the player is invincible
    var clearHighScoresOnLoad = false    // if true, all of the high scores are cleared when the app is loaded
    var restartLevelOnDeath = true      // if true, a level restarts when the player dies
    var clearProgressOnQuit = false       // if true, the play will not be able to pick up where they left off when quitting

    var showTutorial = false              // if false, the tutorial will never be shown
    var clearPlayerProgress = false      // if true, all player progress will be cleared
    var clearGlobalSettings = false      // if true, all global settings will be cleared
    
    // visual debugging
    let showPhysics = false                 // shows physics bodies
    let showBrainRadii = false              // shows the brain radius for each enemy
    let showSpawnVolumesOnMinimap = false   // shows the spawn volume areas as rectangles on the level minimap
    let showTouchHandler = false            // shows a transparent shroud on the touch handler
    
    // singleton instance
    private init() {}
    static let values: WPTConfig = WPTConfig()
}

enum WPTAppMode {
    case NORMAL     // game runs as normal
    case LEVEL      // the game loads a single level and quits when the level is finished
    case WORLDMAP   // load the game as normal, but start from the level map with a pre-configured player
}

func getPreconfiguredPlayerProgress() -> WPTPlayerProgress {
    // Modify this to change the player information when loading into a non-normal mode
    
    let shipName: String = "SHIP NAME"
    let ship: String = "Waypoint Ship"
    
    let health: CGFloat? = nil
    let completedLevels: [String]? = nil
    let cannonBallImage: String? = nil
    let doubloons: Int = 0
    let items: [String]? = ["Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring", "Life Ring"]
//    let items: [String]? = [String]()
//    let items: [String]? = ["Oar", "Gun Powder", "Spiked Cannon Ball", "Propeller", "Rudder", "Sail", "Telescope", "Ship's Wheel", "Hook Hand", "Eyepatch"]
    let cannonSet: [Int:Bool]? = nil
    
    let progress = WPTPlayerProgress(shipName: shipName, ship: ship, health: health, completedLevels: completedLevels, cannonBallImage: cannonBallImage, doubloons: doubloons, items: items, cannonSet: cannonSet)
    
    return progress
}

class WPTLevelModeConfig {

    let levelFileName: String = "10_high_seas"  // the name of the level file to load
    
    // singleton instance
    private init() {}
    static let values: WPTLevelModeConfig = WPTLevelModeConfig()
}

class WPTWorldMapModeConfig {
    
    // singleton instance
    private init() {}
    static let values: WPTWorldMapModeConfig = WPTWorldMapModeConfig()
}
