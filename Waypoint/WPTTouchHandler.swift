//
//  WPTTouchHandler.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/17/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

protocol WPTTouchHandler {    
    func handleTouchStart(_ touch: UITouch) -> Bool
    func handleTouchEnd(_ touch: UITouch) -> Bool
}
