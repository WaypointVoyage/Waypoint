//
//  WPTConfigTest.swift
//  WaypointContentTests
//
//  Created by Cameron Taylor on 9/30/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import XCTest
@testable import Waypoint


class WPTConfigTest: XCTestCase {
    
    func testConfigInNormalMode() {
        XCTAssertEqual(WPTConfig.values.mode, WPTAppMode.NORMAL, "Please change WPTConfig.values.mode to WPTAppMode.NORMAL before commiting.")
    }
    
    func testConfigAudioSettings() {
        XCTAssertTrue(WPTConfig.values.playMusic, "Please set playMusic to true in WPTConfig")
        XCTAssertTrue(WPTConfig.values.playSoundEffects, "Please set playSoundEffects to true in WPTConfig")
    }
    
    func testConfigTestingSettings() {
        XCTAssertFalse(WPTConfig.values.testing, "Please set testing to false in WPTConfig")
        XCTAssertFalse(WPTConfig.values.allUnlocked, "Please set allUnlocked to false in WPTConfig")
        XCTAssertFalse(WPTConfig.values.invincible, "Please set invincible to false in WPTConfig")
        XCTAssertFalse(WPTConfig.values.clearHighScoresOnLoad, "Please set clearHighScoresOnLoad to false in WPTConfig")
        XCTAssertTrue(WPTConfig.values.showTutorial, "Please set showTutorial to true in WPTConfig")
    }
    
    func testConfigVisualDebuggingSettings() {
        XCTAssertFalse(WPTConfig.values.showPhysics, "Please set showPhysics to false in WPTConfig")
        XCTAssertFalse(WPTConfig.values.showBrainRadii, "Please set showBrainRadii to false in WPTConfig")
        XCTAssertFalse(WPTConfig.values.showSpawnVolumesOnMinimap, "Please set showSpawnVolumesOnMinimap to false in WPTConfig")
        XCTAssertFalse(WPTConfig.values.showTouchHandler, "Please set showTouchHandler to false in WPTConfig")
    }
}
