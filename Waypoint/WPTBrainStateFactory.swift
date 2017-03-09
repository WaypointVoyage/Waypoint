//
//  WPTBrainStateFactory.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTBrainStateFactory {
    static func get(_ state: String) -> WPTBrainState {
        switch (state) {
            
        case String(describing: WPTStandAndShootBS.self):
            return WPTStandAndShootBS()
            
        default:
            assert(false, "Unknown WPTBrainState: \(state)")
        }
    }
}
