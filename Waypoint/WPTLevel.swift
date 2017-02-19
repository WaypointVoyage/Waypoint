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
    
    init(_ levelFileNamed: String) {
        let plistPath = Bundle.main.path(forResource: levelFileNamed, ofType: "plist")!
        let levelDict = NSDictionary(contentsOfFile: plistPath) as! [String: AnyObject]
        
        self.name = levelDict["name"] as! String
        
        let sizeDict = levelDict["size"] as! [String: CGFloat]
        self.size = CGSize(width: sizeDict["width"]!, height: sizeDict["height"]!)
        
        let spawnDict = levelDict["spawnPoint"] as! [String: CGFloat]
        self.spawnPoint = CGPoint(x: spawnDict["x"]!, y: spawnDict["y"]!)
    }
}
