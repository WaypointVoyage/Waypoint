//
//  StorageTests.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/21/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import XCTest
@testable import Waypoint

class StorageTests: XCTestCase {
    var player: WPTPlayer! = nil
    var ship: WPTShip! = nil
    
    override func setUp() {
        super.setUp();
        ship = WPTShip(name: "NAME", previewImage: "IMG_NAME", inGameImage: "Ingameimagename")
        player = WPTPlayer(ship: ship, shipName: "SHIP_NAME", completedLevels: ["a_level", "another_level"])
    }
    
    func testProgressPersistance() {
        let prog = WPTPlayerProgress(player: player)
        let storage = WPTStorage()
        storage.savePlayerProgress(prog)
        
        let loaded = storage.loadPlayerProgress()
        
        XCTAssert(loaded != nil)
        
        XCTAssert(loaded!.shipName == prog.shipName)
        XCTAssert(loaded!.health == prog.health)
        XCTAssert(loaded!.completedLevels == prog.completedLevels)
        XCTAssert(loaded!.ship == prog.ship)
        XCTAssert(loaded!.cannonBallImage == prog.cannonBallImage)
        XCTAssert(loaded!.doubloons == prog.doubloons)
        XCTAssert(loaded!.items == prog.items)
        XCTAssert(loaded!.cannonSet == prog.cannonSet)
    }
    
    func testProgressDelete() {
        let storage = WPTStorage()
    }
}
