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
    
    let player: WPTLevelPlayerNode
    var enemies = [WPTLevelEnemyNode]()
    
    var port: WPTPortNode? {
        return self.childNode(withName: WPTPortNode.nodeNameTag) as? WPTPortNode
    }
    
    init(level: WPTLevel, player: WPTLevelPlayerNode) {
        self.level = level
        self.size = level.size
        self.spawnPoint = level.spawnPoint
        self.boundary = nil
        self.player = player
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
        water!.zPosition = WPTValues.waterZPosition
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
    
    func addEnemy(_ enemy: WPTLevelEnemyNode?) {
        if let enemy = enemy {
            enemy.removeFromParent()
            self.addChild(enemy)
            self.enemies.append(enemy)
        }
    }
    
    func removeEnemy(_ enemy: WPTLevelEnemyNode) {
        enemy.removeFromParent()
        for i in 0..<enemies.count {
            if enemies[i] == enemy {
                enemies.remove(at: i)
                return
            }
        }
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
    
    public func randomPoint(borderWidth: CGFloat, onLand: Bool? = nil, inCameraView: Bool? = nil) -> CGPoint {
        for _ in 0..<2000 {
            var rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let xPos = borderWidth + rand * CGFloat(self.size.width - 2 * borderWidth)
            rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let yPos = borderWidth + rand * CGFloat(self.size.height - 2 * borderWidth)
            let point = CGPoint(x: xPos, y: yPos)
            
            // test restrictions
            var restrictionsPassed = true
            if let onLand = onLand {
                let onLandTest = pointOnLand(terrainPoint: point)
                if onLandTest != onLand {
                    restrictionsPassed = false
                }
            }
            if let inCameraView = inCameraView {
                let inCameraViewTest = pointInCameraView(terrainPoint: point)
                if inCameraViewTest != inCameraView {
                    restrictionsPassed = false
                }
            }
            
            if restrictionsPassed {
                return point
            }
        }
        NSLog("WARN: after 2000 tries, couldn't get random terrain point...")
        return CGPoint.zero
    }
    
    public func pointOnLand(terrainPoint p: CGPoint) -> Bool {
        for path in self.terrainPaths {
            if path.contains(p) {
                return true
            }
        }
        return false
    }
    
    public func pointOnLand(scenePoint p: CGPoint) -> Bool {
        let point = self.convert(p, from: self.scene!)
        return pointOnLand(terrainPoint: point)
    }
    
    public func pointInCameraView(terrainPoint p: CGPoint) -> Bool {
        let camPos = (self.scene as! WPTLevelScene).cam.position
        let minx = camPos.x - WPTValues.screenSize.width;
        let maxx = camPos.x + WPTValues.screenSize.width;
        let miny = camPos.y - WPTValues.screenSize.height;
        let maxy = camPos.y + WPTValues.screenSize.height;
        return minx <= p.x && p.x <= maxx && miny <= p.y && p.y <= maxy
    }
    
    public func pointInCameraView(scenePoint p: CGPoint) -> Bool {
        let point = self.convert(p, from: self.scene!)
        return pointInCameraView(terrainPoint: point)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
