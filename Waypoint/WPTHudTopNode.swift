//
//  WPTHudTopNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHudTopNode: SKNode, WPTUpdatable {
    
    private let player: WPTPlayer
    
    init(player: WPTPlayer) {
        self.player = player
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval) {
        
    }
}
