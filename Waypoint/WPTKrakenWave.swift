//
//  WPTKrakenWave.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 5 in the final boss
class WPTKrakenWave: WPTTentacleWave {
    
    private var kraken: WPTLevelEnemyNode! = nil
    private let krakenLocation: CGPoint
    private let bubbleDuration: TimeInterval
    private let tentacleBubbleDuration: TimeInterval
    private var krakenIsDead: Bool = false
    
    private let tentacleSpawnRadius: CGFloat
    
    override init(_ waveDict: [String: AnyObject]) {
        let krakenLocationDict = waveDict["krakenLocation"] as! [String:CGFloat]
        self.krakenLocation = CGPoint(x: krakenLocationDict["x"]!, y: krakenLocationDict["y"]!)
        self.bubbleDuration = waveDict["bubbleDuration"] as! TimeInterval
        self.tentacleSpawnRadius = waveDict["tentacleSpawnRadius"] as! CGFloat
        self.tentacleBubbleDuration = waveDict["tentacleBubbleDuration"] as! TimeInterval
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene, isStatic: false)
        self.spawnKraken()
        self.spawnTentacles()
    }
    
    private func spawnTentacles() {
        let spawnLocations = self.getTentacleSpawnLocations()
        assert(spawnLocations.count == self.tentacleCount)
        
        let wait = SKAction.wait(forDuration: self.tentacleBubbleDuration)
        for i in 0..<self.tentacleCount {
            self.tentacles[i].position = spawnLocations[i]
            self.tentacles[i].submerge(duration: 0)
            self.tentacles[i].setBubbles(true)
            self.scene.terrain.addEnemy(self.tentacles[i])
            
            self.tentacles[i].run(wait) {
                self.tentacles[i].surface(duration: 3.0)
            }
        }
    }
    
    private func getTentacleSpawnLocations() -> [CGPoint] {
        var result = [self.angleToSpawnLocation(CG_PI)]
        
        if self.tentacleCount > 1 {
            let deltaAngle = CG_PI / CGFloat(self.tentacleCount - 1)
            for i in 1..<self.tentacleCount {
                result.append(self.angleToSpawnLocation(CG_PI + CGFloat(i) * deltaAngle))
            }
        }
        
        return result
    }
    
    private func angleToSpawnLocation(_ angle: CGFloat) -> CGPoint {
        return self.krakenLocation + self.tentacleSpawnRadius * CGVector(radians: angle)
    }
    
    private func spawnKraken() {
        self.kraken = WPTLevelEnemyNode(enemy: WPTEnemyCatalog.enemiesByName["Kraken"]!, player: self.scene.player)
        self.kraken.position = self.krakenLocation
        self.kraken.onDeath {
            self.krakenIsDead = true
        }
        
        let bubbles = WPTBubbleSquareSurfaceNode(width: 1000, height: 600, amount: 3, time: 0.6)
        bubbles.position = self.krakenLocation
        
        self.scene.terrain.addChild(bubbles)
        bubbles.run(SKAction.wait(forDuration: self.bubbleDuration)) {
            self.scene.terrain.addEnemy(self.kraken)
            
            bubbles.run(SKAction.wait(forDuration: 1.0)) {
                bubbles.removeFromParent()
            }
        }
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        return self.krakenIsDead && super.isComplete(scene: scene)
    }
}
