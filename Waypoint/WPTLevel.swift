//
//  WPTLevel.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/13/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevel {
    
    let name: String
    let size: CGSize
    let spawnPoint: CGPoint
    let terrainImage: String?
    let waterImage: String?
    let terrainBodies: [[[CGFloat]]]?
    
    init(_ levelFileNamed: String) {
        let plistPath = Bundle.main.path(forResource: levelFileNamed, ofType: "plist")!
        let levelDict = NSDictionary(contentsOfFile: plistPath) as! [String: AnyObject]
        
        self.name = levelDict["name"] as! String
        
        let sizeDict = levelDict["size"] as! [String: CGFloat]
        self.size = CGSize(width: sizeDict["width"]!, height: sizeDict["height"]!)
        
        let spawnDict = levelDict["spawnPoint"] as! [String: CGFloat]
        self.spawnPoint = CGPoint(x: spawnDict["x"]!, y: spawnDict["y"]!)
        
        if let terrainDict = levelDict["terrain"] as? [String:AnyObject] {
            self.terrainImage = terrainDict["image"] as? String
            self.waterImage = terrainDict["waterImage"] as? String
            self.terrainBodies = terrainDict["bodies"] as? [[[CGFloat]]]
        } else {
            self.terrainImage = nil
            self.waterImage = nil
            self.terrainBodies = nil
        }
    }
}
