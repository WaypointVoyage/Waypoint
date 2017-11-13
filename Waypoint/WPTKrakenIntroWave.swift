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
    private var treasureChest: WPTFinalTreasureNode? {
        return self.scene.terrain.childNode(withName: WPTFinalTreasureNode.TREASURE_NODE_NAME) as? WPTFinalTreasureNode
    }
    
    override init(_ waveDict: [String:AnyObject]) {
        
        let healthPickupsArray = waveDict["healthPickups"] as! [[String:Int]]
        for loc in healthPickupsArray {
            self.healthLocations.append(CGPoint(x: loc["x"]!, y: loc["y"]!))
        }
        
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        self.setHealthPickups()
    }
    
    private func setHealthPickups() {
        for loc in self.healthLocations {
            let health = WPTItemCatalog.itemsByName["Ship Maintenance Major"]!
            let healthNode = WPTItemNode(health)
            healthNode.position = loc
            
            self.scene.terrain.addChild(healthNode)
        }
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        let chest = self.treasureChest
        guard chest != nil else { return false }
        let dist = CGVector(start: chest!.position, end: self.scene.player.position).magnitude()
        return dist < chest!.activationDistance
    }
}

