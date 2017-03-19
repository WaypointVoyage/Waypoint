//
//  WPTLevelWave.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelWave {
    var next: WPTLevelWave?
    
    public private(set) var enemies = [WPTEnemy:Int]()
    
    init(_ waveDict: [String:AnyObject]) {
        if let enemies = waveDict["enemies"] as? [String:Int] {
            for (name, quantity) in enemies {
                let enemy = WPTEnemyCatalog.enemiesByName[name]!
                let cur: Int = self.enemies[enemy] ?? 0
                self.enemies[enemy] = quantity + cur
            }
        }
    }
}
