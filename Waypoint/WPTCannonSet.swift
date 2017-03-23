//
//  WPTCannonSet.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTCannonSet {
    public private(set) var cannons = [WPTCannon]()
    
    init(_ dict: [[String:AnyObject]]) {
        for cannonJson in dict {
            self.cannons.append(WPTCannon(cannonJson))
        }
    }
    
    init(other: WPTCannonSet) {
        for cannon in other.cannons {
            self.cannons.append(WPTCannon(hasCannon: cannon.hasCannon, position: cannon.position, angle: cannon.angle))
        }
    }
}
