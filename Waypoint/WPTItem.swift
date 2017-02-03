//
//  WPTItem.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/3/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTItem {
    let name: String
    let imageName: String
    
    let typeMask: Int
    let multiplicity: Int? // the number of times the item's effects can be applied to an actor
    
    init(name: String, imageName: String, typeMask: Int, multiplicity: Int?) {
        self.name = name
        self.imageName = imageName
        self.typeMask = typeMask
        self.multiplicity = multiplicity
    }
    
    func isOf(type: Int) -> Bool {
        return self.typeMask & type != 0
    }
}

struct WPTItemTypes {
    static let shipModifier: Int = 1 << 0
    static let cannonModifier: Int = 1 << 1
    static let actorModifier: Int = 1 << 2
    
}
