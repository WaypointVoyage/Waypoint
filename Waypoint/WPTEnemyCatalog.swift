//
//  WPTEnemyCatalog.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTEnemyCatalog {
    
    static let allBrainTemplates: [WPTBrainTemplate] = {
        var brains = [WPTBrainTemplate]()
        
        let path = Bundle.main.path(forResource: "brains", ofType: "plist")!
        for brain in NSArray(contentsOfFile: path) as! [[String:AnyObject]] {
            brains.append(WPTBrainTemplate(brain))
        }
        
        return brains;
    }()
    
    static let brainTemplatesByName: [String:WPTBrainTemplate] = {
        var map = [String:WPTBrainTemplate]()
        for brain in WPTEnemyCatalog.allBrainTemplates {
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
