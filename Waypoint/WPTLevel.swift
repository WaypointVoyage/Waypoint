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
    
    let port: WPTPort?
    
    // terrain
    let terrainImage: String?
    let waterImage: String?
    let terrainBodies: [[[CGFloat]]]?
    
    // obstacles
    let whirlpools: Int
    var whirlpoolLocations = [CGPoint]()
    let boulders: Int
    
    let hasTutorial: Bool = true
    
    init(_ levelFileNamed: String) {
        let plistPath = Bundle.main.path(forResource: levelFileNamed, ofType: "plist")!
        let levelDict = NSDictionary(contentsOfFile: plistPath) as! [String: AnyObject]
        
        self.name = levelDict["name"] as! String
        
        let sizeDict = levelDict["size"] as! [String: CGFloat]
        self.size = CGSize(width: sizeDict["width"]!, height: sizeDict["height"]!)
        
        let spawnDict = levelDict["spawnPoint"] as! [String: CGFloat]
        self.spawnPoint = CGPoint(x: spawnDict["x"]!, y: spawnDict["y"]!)
        
        // port
        if let portDict = levelDict["port"] as? [String:AnyObject] {
            port = WPTPort(portDict)
        } else {
            port = nil
        }
        
        // terrain
        if let terrainDict = levelDict["terrain"] as? [String:AnyObject] {
            self.terrainImage = (terrainDict["image"] as! String)
            self.waterImage = (terrainDict["waterImage"] as! String)
            self.terrainBodies = (terrainDict["bodies"] as! [[[CGFloat]]])
        } else {
            self.terrainImage = nil
            self.waterImage = nil
            self.terrainBodies = nil
        }
        
        // obstacles
        if let obstaclesDict = levelDict["entities"] as? [String:AnyObject] {
            self.whirlpools = obstaclesDict["whirlpools"] as! Int
            self.boulders = obstaclesDict["boulders"] as! Int
            for point in obstaclesDict["whirlpoolLocations"] as! [[CGFloat]] {
                whirlpoolLocations.append(CGPoint(x: point[0], y: point[1]))
            }
        } else {
            self.whirlpools = 0
            self.boulders = 0
        }
    }
}
