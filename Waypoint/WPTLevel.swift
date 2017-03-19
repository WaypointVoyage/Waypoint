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
    
    let hasTutorial: Bool
    
    // spawn volumes
    public private(set) var spawnVolumes = [CGRect]()
    
    // waves
    public private(set) var waves = [WPTLevelWave]()
    
    init(_ levelFileNamed: String) {
        let plistPath = Bundle.main.path(forResource: levelFileNamed, ofType: "plist")!
        let levelDict = NSDictionary(contentsOfFile: plistPath) as! [String: AnyObject]
        
        self.name = levelDict["name"] as! String
        self.hasTutorial = (levelDict["hasTutorial"] as? Bool) == true
        
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
        
        // spawn volumes
        if let volumesArr = levelDict["spawnVolumes"] as? [[String:CGFloat]] {
            for vol in volumesArr {
                let minx = vol["minx"]!
                let maxx = vol["maxx"]!
                let miny = vol["miny"]!
                let maxy = vol["maxy"]!
                assert(maxx > minx && maxy > miny, "Invalid spawn volume")
                let rect = CGRect(x: minx, y: miny, width: maxx - minx, height: maxy - miny)
                self.spawnVolumes.append(rect)
            }
        }
        
        // waves
        if let allWaveDicts = levelDict["waves"] as? [[String:AnyObject]] {
            for waveDict in allWaveDicts {
                self.waves.append(WPTLevelWave(waveDict))
            }
            for i in 0..<(self.waves.count-1) {
                self.waves[i].next = self.waves[i + 1]
            }
        }
    }
    
    func randomSpawnVolume() -> CGRect {
        let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let index = CGFloat(spawnVolumes.count - 1) * rand
        return self.spawnVolumes[Int(index)]
    }
}
