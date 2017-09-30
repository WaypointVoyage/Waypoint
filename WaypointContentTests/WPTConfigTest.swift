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
    
}
