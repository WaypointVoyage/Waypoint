//
//  WPTCannon.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTCannon {
    var hasCannon: Bool
    var position: CGPoint
    var angle: CGFloat
    
    init(_ dict: [String:AnyObject]) {
        self.hasCannon = dict["hasCannon"] as! Bool
        self.position = CGPoint(x: dict["x"] as! CGFloat, y: dict["y"] as! CGFloat)
        self.angle = dict["angle"] as! CGFloat
    }
}
