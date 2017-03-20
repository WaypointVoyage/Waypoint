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
    static let lineWidth: CGFloat = 25
    static let strokeColor = UIColor(red: 0.31, green: 0.2, blue: 0, alpha: 1)
    static let fillColor = UIColor(red: 0.6, green: 0.38, blue: 0.23, alpha: 0.4)
    
    private let terrain: WPTTerrainNode
    var width: CGFloat {
        return terrain.size.width
    }
    var height: CGFloat {
        return terrain.size.height
    }
    
    private var player: SKShapeNode! = nil
    private var enemies = SKNode()
    private let offset: CGPoint
    
    init(terrain: WPTTerrainNode) {
        self.terrain = terrain
        offset = CGPoint(x: -terrain.size.width / 2, y: -terrain.size.height / 2)
        super.init()
        
        
        // border
        let border = SKShapeNode(rectOf: terrain.size)
        border.strokeColor = WPTMapView.strokeColor
        border.lineWidth = WPTMapView.lineWidth
        self.addChild(border)
        
        // terrain
        for path in terrain.terrainPaths {
            let landMass = SKShapeNode(path: path)
            landMass.fillColor = WPTMapView.fillColor
            landMass.strokeColor = WPTMapView.strokeColor
            landMass.lineWidth = WPTMapView.lineWidth
            landMass.position = offset
            self.addChild(landMass)
        }
        
        // player
        player = SKShapeNode(circleOfRadius: 4 * WPTMapView.lineWidth)
        player.fillColor = WPTMapView.strokeColor
        self.addChild(player)
        
        self.addChild(enemies)
    }
    
    func drawSpawnVolumes(_ volumes: [CGRect]) {
        for sv in volumes {
            let svn = SKShapeNode(rect: sv)
            svn.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.4)
            svn.strokeColor = .blue
            svn.lineWidth = WPTMapView.lineWidth
            svn.position = offset
            self.addChild(svn)
        }
    }
    
    func updateActorPositions() {
        // player
        let offset = CGPoint(x: -terrain.size.width / 2, y: -terrain.size.height / 2)
        player.position = terrain.player.position + offset
        
        // enemies
        self.enemies.removeAllChildren()
        for enemy in terrain.enemies {
            let shape = SKShapeNode(circleOfRadius: 2 * WPTMapView.lineWidth)
            shape.fillColor = UIColor.red
            shape.position = enemy.position + offset
            self.enemies.addChild(shape)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
