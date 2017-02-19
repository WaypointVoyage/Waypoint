//
//  WPTCannonNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTCannonNode: SKNode {
    
    private let cannonSet: WPTCannonSet
    
    init(_ cannonSet: WPTCannonSet) {
        self.cannonSet = cannonSet
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
