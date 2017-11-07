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
    let number: Int
    let size: CGSize
    let spawnPoint: CGPoint
    let difficulty: CGFloat  // augments various components of the level to scale difficulty
    
    let port: WPTPort?
    
    // terrain
    let terrainImage: String?
    let waterImage: String?
    let terrainBodies: [[[CGFloat]]]?
    
    // obstacles
    let boulders: Int
    let whirlpoolPeriod: TimeInterval?
    
    let hasTutorial: Bool
    
    // spawn volumes
    public private(set) var spawnVolumes = [CGRect]()
    
    // waves
    public private(set) var waves = [WPTLevelWave]()
    
    // special values for special waves
    var xMarksTheSpot: CGPoint? = nil
    
    init(_ levelFileNamed: String) {
        let plistPath = Bundle.main.path(forResource: levelFileNamed, ofType: "plist")!
        let levelDict = NSDictionary(contentsOfFile: plistPath) as! [String: AnyObject]
        self.name = levelDict["name"] as! String
        
        self.number = levelDict["number"] as! Int
        
        self.hasTutorial = (levelDict["hasTutorial"] as? Bool) == true
        
        self.difficulty = levelDict["difficulty"] as! CGFloat
        
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
            self.boulders = obstaclesDict["boulders"] as! Int
            self.whirlpoolPeriod = obstaclesDict["whirlpoolPeriod"] as? TimeInterval
        } else {
            self.boulders = 0
            self.whirlpoolPeriod = nil
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
            // build all the waves
            for waveDict in allWaveDicts {
                if let special = waveDict["special"] as? String {
                    switch (special) {
                    case String(describing: WPTKrakenIntroWave.self):
                        self.waves.append(WPTKrakenIntroWave(waveDict))
                    case String(describing: WPTKrakenChestStealWave.self):
                        self.waves.append(WPTKrakenChestStealWave(waveDict))
                    case String(describing: WPTTentacle1Wave.self):
                        self.waves.append(WPTTentacle1Wave(waveDict))
                    case String(describing: WPTTentacle2Wave.self):
                        self.waves.append(WPTTentacle2Wave(waveDict))
                    case String(describing: WPTKrakenWave.self):
                        self.waves.append(WPTKrakenWave(waveDict))
                    case String(describing: WPTTreasureReturnsWave.self):
                        self.waves.append(WPTTreasureReturnsWave(waveDict))
                    case String(describing: WPTTreasureWave.self):
                        assert(xMarksTheSpot == nil, "Can only have one treasure wave per level")
                        self.waves.append(WPTTreasureWave(waveDict))
                        let spot = waveDict["xMarksTheSpot"] as! [String:CGFloat]
                        xMarksTheSpot = CGPoint(x: spot["x"]!, y: spot["y"]!)
                    default:
                        assert(false, "Could not identify the special wave: \(special).")
                    }
                } else {
                    self.waves.append(WPTLevelWave(waveDict))
                }
            }
            
            // hook up the linked list structure
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
