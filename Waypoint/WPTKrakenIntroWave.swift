//
//  WPTKrakenIntro.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// Wave 1 in the final boss
class WPTKrakenIntroWave: WPTLevelWave {
    
    private var healthLocations: [CGPoint] = [CGPoint]()
    private let treasureChest: WPTFinalTreasureNode = WPTFinalTreasureNode()
    
    override init(_ waveDict: [String:AnyObject]) {
        
        let healthPickupsArray = waveDict["healthPickups"] as! [[String:Int]]
        for loc in healthPickupsArray {
            self.healthLocations.append(CGPoint(x: loc["x"]!, y: loc["y"]!))
        }
        
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        
        self.spawnTreasureChest()
        self.setHealthPickups()
    }
    
    private func spawnTreasureChest() {
        self.treasureChest.position = scene.level.xMarksTheSpot!
        self.treasureChest.removeFromParent()
        self.scene.terrain.addChild(treasureChest)
    }
    
    private func setHealthPickups() {
        for loc in self.healthLocations {
            let health = WPTItemCatalog.itemsByName["Ship Maintenance"]!
            let healthNode = WPTItemNode(health)
            healthNode.position = loc
            
            self.scene.terrain.addChild(healthNode)
        }
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        let dist = CGVector(start: self.treasureChest.position, end: self.scene.player.position).magnitude()
        return dist < self.treasureChest.activationDistance
    }
}

