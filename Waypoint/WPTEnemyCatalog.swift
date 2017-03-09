//
//  WPTEnemyCatalog.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTEnemyCatalog {
    
    static let allBrains: [WPTBrain] = {
        var brains = [WPTBrain]()
        
        let path = Bundle.main.path(forResource: "brains", ofType: "plist")!
        for brain in NSArray(contentsOfFile: path) as! [[String:AnyObject]] {
            brains.append(WPTBrain(brain))
        }
        
        return brains;
    }()
    
    static let brainsByName: [String:WPTBrain] = {
        var map = [String:WPTBrain]()
        for brain in WPTEnemyCatalog.allBrains {
            map[brain.name] = brain
        }
        return map
    }()
    
    static let allEnemies: [WPTEnemy] = {
        var enemies = [WPTEnemy]()
        
        let path = Bundle.main.path(forResource: "enemies", ofType: "plist")!
        for enemy in NSArray(contentsOfFile: path) as! [[String:AnyObject]] {
            enemies.append(WPTEnemy(enemy))
        }
        
        return enemies;
    }()
    
    static let enemiesByName: [String:WPTEnemy] = {
        var map = [String:WPTEnemy]()
        for enemy in WPTEnemyCatalog.allEnemies {
            map[enemy.name] = enemy;
        }
        return map
    }()
}
