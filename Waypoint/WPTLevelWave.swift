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
    
    // Override for special setup
    //      called after all of the enemies have been placed in the scene.
    func setup(scene: WPTLevelScene) {}
    
    // Override to check if the level is complete
    //      default is when all of the enemies have been killed
    func isComplete(scene: WPTLevelScene) -> Bool {
        return scene.terrain.enemies.count <= 0
    }
    
    // Override for special teardown
    //      called after the wave is considered complete and 
    //      finishes asynchronously before the next wave starts
    func teardown(scene: WPTLevelScene) {}
    
    func update(_ deltaTime: TimeInterval) {}
}
