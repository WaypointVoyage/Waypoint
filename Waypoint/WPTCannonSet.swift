//
//  WPTCannonSet.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTCannonSet {
    var numCannons: Int
    var maxCannons: Int
    
    init(dict: [String:AnyObject]) {
        self.numCannons = dict["numCannons"] as! Int
        self.maxCannons = dict["maxCannons"] as! Int
    }
}

// random change
