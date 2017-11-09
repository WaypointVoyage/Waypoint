//
//  WPTLevelWave.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelWave {
    weak var scene: WPTLevelScene! = nil
    var next: WPTLevelWave?
    
    public private(set) var enemies = [WaveEnemy]()
    
    private var landSpawnPoints: [CGPoint]! = nil
    
    init(_ waveDict: [String:AnyObject]) {
        if let enemiesArr = waveDict["enemies"] as? [[String:AnyObject]] {
            for enemyDict in enemiesArr {
                for _ in 0..<(enemyDict["count"] as! Int) {
                    self.enemies.append(WaveEnemy(dict: enemyDict))
                }
            }
        }
    }
    
    // Override for special setup
    //      called after all of the enemies have been placed in the scene.
    func setup(scene: WPTLevelScene) {
        self.scene = scene
        self.landSpawnPoints = self.scene.level.landSpawnPoints // should create a shallow copy
    }
    
    // Override to check if the level is complete
    //      default is when all of the enemies have been killed
    func isComplete(scene: WPTLevelScene) -> Bool {
        return scene.terrain.enemies.count <= 0
    }
    
    // Override for special teardown
    //      called after the wave is considered complete and 
    //      finishes asynchronously before the next wave starts
    //      returning false means that the level beaten stage doesn't happen
    func teardown(scene: WPTLevelScene) -> Bool {
        return true
    }
    
    // Override to implemente update behavior
    func update(_ deltaTime: TimeInterval) {}
    
    // Override for custom actions when the scene is paused
    func pause(paused: Bool) {}
    
    // Determines the spawn point for an enemy in this wave.
    //      the default implementation supports standard waves.
    //      override to implement special spawning in custom waves.
    func enemySpawnPosition(_ enemy: WPTLevelEnemyNode) -> CGPoint? {
        switch enemy.enemy.terrainType {
        case WPTEnemyTerrainType.land:
            return landSpawnPoint(enemy)
        case WPTEnemyTerrainType.sea:
            return waterSpawnPoint(enemy)
        default:
            return nil
        }
    }

    private func landSpawnPoint(_ enemy: WPTLevelEnemyNode) -> CGPoint {
        if self.landSpawnPoints.count > 0 {
            // choose a random point from the possible positions
            let index = Int(randomNumber(min: 0, max: CGFloat(self.landSpawnPoints.count)))
            return self.landSpawnPoints.remove(at: index)
        } else {
            // otherwise, randomly generate a point
            NSLog("WARNING: there are no more land spawn points to choose from, generating random point")
            return scene.terrain.randomPoint(borderWidth: enemy.sprite.frame.width / 2, onLand: true)
        }
    }
    
    private func waterSpawnPoint(_ enemy: WPTLevelEnemyNode) -> CGPoint {
        assert(scene.level.spawnVolumes.count > 0, "Cannot place water based enemies without a spawn volume!")
        
        let spawnVol = scene.level.randomSpawnVolume()
        
        var rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let xpos = spawnVol.minX + rand * (spawnVol.width)
        
        rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let ypos = spawnVol.minY + rand * (spawnVol.height)
        
        return CGPoint(x: xpos, y: ypos)
    }
}

class WaveEnemy {
    public let enemy: WPTEnemy
    public private(set) var items: [WPTItem]
    
    init(dict: [String:AnyObject]) {
        let enemyName = dict["enemy"] as! String
        self.enemy = WPTEnemy(other: WPTEnemyCatalog.enemiesByName[enemyName]!)

        self.items = [WPTItem]()
        for itemName in dict["items"] as! [String] {
            self.items.append(WPTItemCatalog.itemsByName[itemName]!)
        }
    }
}
