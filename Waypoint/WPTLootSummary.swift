//
//  WPTLootSummary.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLootSummary: NSObject, Comparable, Codable {
    let shipName: String
    let doubloons: Int
    let date: Date
    let items: [String]

    init(shipName: String, doubloons: Int, date: Date, items: [String]) {
        self.shipName = shipName
        self.doubloons = doubloons
        self.date = date
        self.items = items
    }

    init(player: WPTLevelPlayerNode) {
        self.shipName = player.player.shipName
        self.doubloons = player.doubloons
        items = player.player.items.map { $0.name }
        
        date = Date()
    }

    static func ==(lhs: WPTLootSummary, rhs: WPTLootSummary) -> Bool {
        return lhs.doubloons == rhs.doubloons
    }

    static func <(lhs: WPTLootSummary, rhs: WPTLootSummary) -> Bool {
        return lhs.doubloons > rhs.doubloons
    }
}
