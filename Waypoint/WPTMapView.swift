//
//  WPTMapView.swift
//  Waypoint
//
//  Created by Hilary Schulz on 2/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

import SpriteKit


class WPTMapView: SKNode {
    
    var terrainPaths = [CGPath]()
    
    
    init(terrain: WPTTerrainNode) {
        super.init()

        print("Level Scene: \(scene)")
        self.terrainPaths = terrain.terrainPaths
        
        for path in terrainPaths {
            let landMass = SKShapeNode(path: path)
            landMass.lineWidth = 3
            landMass.fillColor = UIColor.brown
            self.addChild(landMass)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
