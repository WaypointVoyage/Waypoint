//
//  WPTDockNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTDockNode: SKNode {
    weak var port: WPTPortNode?
    
    init(_ port: WPTPortNode) {
        self.port = port
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
