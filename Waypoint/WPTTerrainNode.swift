//
//  WPTTerrainNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/16/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTerrainNode: SKNode {
    private let waterShader = SKShader(fileNamed: "water.fsh")
    
    let level: WPTLevel
    let size: CGSize
    let spawnPoint: CGPoint
    var terrainPaths = [CGPath]()
    
    var boundary: SKPhysicsBody!
    
    init(level: WPTLevel, player: WPTLevelPlayerNode) {
        self.level = level
        self.size = level.size
        self.spawnPoint = level.spawnPoint
        self.boundary = nil
        super.init()
        
        // setup the water backdrop
        var water: SKNode? = nil
        if let waterImage = level.waterImage {
            let asSprite = SKSpriteNode(imageNamed: waterImage)
            asSprite.anchorPoint = CGPoint.zero
            water = asSprite
        } else {
            let asShape = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: self.size))
            asShape.fillShader = self.waterShader
            asShape.strokeColor = UIColor.purple
            asShape.lineWidth = 5
            water = asShape
        }
        water!.zPosition = -100
        self.addChild(water!)
        
        // and the touch handler
        self.addChild(WPTPlayerMovementNode(self.size, player))
        
        loadTerrain()
        
        // put a boundary on the scene
        self.boundary = SKPhysicsBody(edgeLoopFrom: water!.frame)
        self.physicsBody = boundary
        boundary.categoryBitMask = WPTValues.boundaryCbm
        boundary.collisionBitMask = WPTValues.actorCbm
    }
    
    private func loadTerrain() {
        // if there is a terrain file, show it
        if let terrainImg = level.terrainImage {
            let terrain = SKSpriteNode(imageNamed: terrainImg)
            terrain.anchorPoint = CGPoint.zero
            terrain.zPosition = -98

            // handle the terrain bodies
            if let bodies = level.terrainBodies {
                var physicsBodies = [SKPhysicsBody]()
                
                for body in bodies {
                    let path = CGMutablePath()
                    path.move(to: 2.0 * CGPoint(x: body[0][0], y: body[0][1]))
                    for i in 1..<body.count {
                        path.addLine(to: 2.0 * CGPoint(x: body[i][0], y: body[i][1]))
                    }
                    path.closeSubpath()
                    self.terrainPaths.append(path)
                    
                    physicsBodies.append(SKPhysicsBody(edgeLoopFrom: path))
                }
                
                terrain.physicsBody = SKPhysicsBody(bodies: physicsBodies)
                terrain.physicsBody!.isDynamic = false
                terrain.physicsBody!.categoryBitMask = WPTValues.terrainCbm
                terrain.physicsBody!.collisionBitMask = WPTValues.actorCbm | WPTValues.whirlpoolCbm
            }
            
            self.addChild(terrain)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
