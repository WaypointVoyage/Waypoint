//
//  WPTUpdatable.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

protocol WPTUpdatable {
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval)
}
