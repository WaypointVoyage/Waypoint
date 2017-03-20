//
//  WPTLootSummary.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTLootSummary: Comparable {
    let shipName: String
    let doubloons: Int
    let date: Date
    
    init(shipName: String, doubloons: Int) {
        self.shipName = shipName
        self.doubloons = doubloons
        
        date = Date()
    }
    
    static func ==(lhs: WPTLootSummary, rhs: WPTLootSummary) -> Bool {
        return lhs.doubloons == rhs.doubloons
    }
    
    static func <(lhs: WPTLootSummary, rhs: WPTLootSummary) -> Bool {
        return lhs.doubloons < rhs.doubloons
    }
}
