//
//  WPTPort.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/3/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPort {
    
    let position: CGPoint
    let angle: CGFloat
    
    // loading from plist
    init(_ portDict: [String:AnyObject]) {
        let posDict = portDict["position"] as! [String:CGFloat]
        position = CGPoint(x: posDict["x"]!, y: posDict["y"]!)
        angle = posDict["angle"]!
    }
}
