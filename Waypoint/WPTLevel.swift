//
//  WPTLevel.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/13/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTLevel {
    
    let name: String
    let beaten: Bool
    
    init(_ levelFileNamed: String, beaten: Bool = false) {
        name = "LEVEL NAME"
        self.beaten = beaten
    }
}
