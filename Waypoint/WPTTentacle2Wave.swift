//
//  WPTTentacle2Wave.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 4 in the final boss
class WPTTentacle2Wave: WPTTentacleWave {
    
    // TODO: test all of this while killing enemies
    
    // TODO: find out why tentacles start to teleport after a while
    
    private let surroundPlayerRadius: CGFloat
    private var chasing: Bool = false
    
    private var curTentacleIndex: Int = -1
    private var curTentacle: WPTLevelTentacleNode {
        return self.tentacles[self.curTentacleIndex]
    }
    
    override init(_ waveDict: [String:AnyObject]) {
        self.surroundPlayerRadius = waveDict["surroundPlayerRadius"] as! CGFloat
        self.chaseBubbleDuration = waveDict["chaseBubbleDuration"] as! TimeInterval
        self.chaseTentacleDuration = waveDict["chaseTentacleDuration"] as! TimeInterval
        self.surroundBubbleDuration = waveDict["surroundBubbleDuration"] as! TimeInterval
        self.surroundTentacleDuration = waveDict["surroundTentacleDuration"] as! TimeInterval
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene, isStatic: true)
        self.startSurroundingPlayer()
    }
    
    private func moveToNextTentacle() {
        self.curTentacleIndex += 1
        if self.curTentacleIndex < self.tentacleCount && self.curTentacle.currentHealth <= 0 {
            self.moveToNextTentacle()
        }
    }
    
    private func spawnTentacle(position: CGPoint, bubbleDuraiton: TimeInterval, tentacle: WPTLevelTentacleNode, tentacleDuration: TimeInterval, then: @escaping () -> Void) {

        tentacle.submerge(duration: 0)
        tentacle.setPosition(position)
        tentacle.setBubbles(true)
        self.scene.terrain.addEnemy(tentacle)
        
        tentacle.run(SKAction.wait(forDuration: bubbleDuraiton)) {
            tentacle.surface()
            tentacle.run(SKAction.wait(forDuration: tentacleDuration)) {
                tentacle.submerge() {
                    self.scene.terrain.removeEnemy(tentacle)
                    tentacle.setBubbles(false)
                    then()
                }
            }
        }
    }
    
    override func onTentacleDead() {
        if self.chasing {
            if !self.allTentaclesDead() {
                self.moveToNextTentacle()
                self.oneChaseTentacle()
            }
        } else {
            self.surroundTentaclesCount -= 1
        }
    }
    
    /////////////////////// CHASE THE PLAYER //////////////////////////
    
    private let chaseBubbleDuration: TimeInterval
    private let chaseTentacleDuration: TimeInterval
    
    private func startChasingPlayer() {
        print("Starting the chase")
        self.chasing = true
        self.curTentacleIndex = -1
        self.moveToNextTentacle()
        self.oneChaseTentacle()
    }
    
    private func oneChaseTentacle() {
        guard !self.allTentaclesDead() else { return }
        
        self.spawnTentacle(position: self.scene.player.position, bubbleDuraiton: self.chaseBubbleDuration, tentacle: self.curTentacle, tentacleDuration: self.chaseTentacleDuration) {
            self.moveToNextTentacle()
            if self.curTentacleIndex < self.tentacleCount {
                self.oneChaseTentacle()         // next tentacle
            } else {
                self.startSurroundingPlayer()   // start surrounding the player
            }
        }
    }
    
    /////////////////////// SURROUND THE PLAYER ///////////////////////
    
    private let surroundBubbleDuration: TimeInterval
    private let surroundTentacleDuration: TimeInterval
    
    private var surroundTentaclesCount: Int = 0
    
    private func startSurroundingPlayer() {
        print("Surround the player!")
        self.chasing = false
        self.curTentacleIndex = -1
        self.surroundTentaclesCount = 0
        self.moveToNextTentacle()
        var points = self.getPlayerSurroundingPoints()
        
        while self.curTentacleIndex < self.tentacleCount && points.count > 0 {
            let point = points.remove(at: 0)
            self.surroundTentaclesCount += 1
            
            self.spawnTentacle(position: point, bubbleDuraiton: self.surroundBubbleDuration, tentacle: self.curTentacle, tentacleDuration: self.surroundTentacleDuration) {
                self.surroundTentaclesCount -= 1
                
                if self.surroundTentaclesCount <= 0 {
                    print("done surrounding")
                    self.finishSurroundTentacles()
                } else {
                    print("... not done surrounding, \(self.surroundTentaclesCount) tentacles left")
                }
            }
            
            self.moveToNextTentacle()
        }
    }
    
    private func finishSurroundTentacles() {
        self.startChasingPlayer()
    }
    
    private var cachedOffsets: [CGPoint]? = nil
    private func getPlayerSurroundingPoints() -> [CGPoint] {
        
        // cache the offsets, no need to calculate more than once
        if cachedOffsets == nil {
            let radius = self.surroundPlayerRadius
            let angleDist: CGFloat = CGFloat(sqrt(2.0) / 2.0) * radius
            self.cachedOffsets = [CGPoint]()
            
            self.cachedOffsets!.append(CGPoint(x: radius, y: 0))                 // 0
            self.cachedOffsets!.append(CGPoint(x: angleDist, y: angleDist))      // pi/4
            self.cachedOffsets!.append(CGPoint(x: 0, y: radius))                 // pi/2
            self.cachedOffsets!.append(CGPoint(x: -angleDist, y: angleDist))     // 3pi/4
            self.cachedOffsets!.append(CGPoint(x: -radius, y: 0))                // pi
            self.cachedOffsets!.append(CGPoint(x: -angleDist, y: -angleDist))    // 5pi/4
            self.cachedOffsets!.append(CGPoint(x: 0, y: -radius))                // 3pi/2
            self.cachedOffsets!.append(CGPoint(x: angleDist, y: -angleDist))     // 7pi/4
        }
        
        // generate the resulting points
        var result = [CGPoint]()
        let center = self.scene.player.position
        for offset in cachedOffsets! {
            let point = center + offset
            if !self.scene.terrain.pointOnLand(scenePoint: point) {
                result.append(point)
            }
        }
        
        return result
    }
}
