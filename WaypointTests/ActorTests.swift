//
//  ActorTests.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import XCTest
@testable import Waypoint

class ActorTests: XCTestCase {
    
    func testItemMultiplicity() {
        let nilItem = WPTItem(name: "a", imageName: "img", typeMask: 0, multiplicity: nil)
        let noMultItem = WPTItem(name: "b", imageName: "img", typeMask: 0, multiplicity: 0)
        let mult3Item = WPTItem(name: "c", imageName: "img", typeMask: 0, multiplicity: 3)
        
        let actor = WPTActor(ship: WPTShip(previewImage: "img", inGameImage: "ingimg"))
        
        XCTAssert(actor.items.count == 0)
        
        let nils = 5
        for _ in 0..<nils {
            actor.apply(item: nilItem)
        }
        
        XCTAssert(actor.items.count == nils)
        
        let noMults = 6
        for _ in 0..<noMults {
            actor.apply(item: noMultItem)
        }
        
        XCTAssert(actor.items.count == nils + noMults)
        
        let mults = 7
        for _ in 0..<mults {
            actor.apply(item: mult3Item)
        }
        
        XCTAssert(actor.items.count == nils + noMults + 3) // only 3 should have been added
    }
}
