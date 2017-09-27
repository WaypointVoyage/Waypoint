//
//  WPTCatalogTests.swift
//  WaypointContentTests
//
//  Created by Cameron Taylor on 9/26/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import XCTest
@testable import Waypoint

class WPTCatalogTests: XCTestCase {
    
    func testWPTEnemyCatalog() {
        
        let _ = WPTEnemyCatalog.allBrainTemplates
        let _ = WPTEnemyCatalog.allEnemies
        let _ = WPTEnemyCatalog.brainTemplatesByName
        let _ = WPTEnemyCatalog.enemiesByName
        
    }
    
    func testWPTItemCatalog() {
        
        let _ = WPTItemCatalog.allItems
        let _ = WPTItemCatalog.currencyItems
        let _ = WPTItemCatalog.itemsByName
        let _ = WPTItemCatalog.repairItems
        
        let randRepair = WPTItemCatalog.randomRepair
        let _ = randRepair()
        let randCurrency = WPTItemCatalog.randomCurrency
        let _ = randCurrency()
        let randStatModifier = WPTItemCatalog.randomStatModifier
        let _ = randStatModifier()
        
    }
    
    func testWPTShipCatalog() {
        let _ = WPTShipCatalog.allShips
        let _ = WPTShipCatalog.playableShips
        let _ = WPTShipCatalog.shipsByName
    }
    
    func testFailingATest() {
        XCTFail()
    }
    
}
