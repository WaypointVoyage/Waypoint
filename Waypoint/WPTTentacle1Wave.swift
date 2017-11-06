//
//  WPTTentacle1Wave.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 3 in the final boss
class WPTTentacle1Wave: WPTTentacleWave {
    
    private let tentacleDuration: TimeInterval
    private let tentacleWait: SKAction
    private var curTentacleIndex: Int = -1
    private var curTentacle: WPTLevelTentacleNode {
        return self.tentacles[self.curTentacleIndex]
    }
    
    private let bubbleDuraiton: TimeInterval
    private let bubbleWait: SKAction
    
    override init(_ waveDict: [String:AnyObject]) {
        self.bubbleDuraiton = waveDict["bubbleDuration"] as! TimeInterval
        self.bubbleWait = SKAction.wait(forDuration: self.bubbleDuraiton)
        self.tentacleDuration = waveDict["tentacleDuration"] as! TimeInterval
        self.tentacleWait = SKAction.wait(forDuration: self.tentacleDuration)
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene, isStatic: true)
        self.startTentacleCycle()
    }
    
    private func moveToNextTentacleIndex() {
        for _ in 0..<self.tentacleCount {
            self.curTentacleIndex = (self.curTentacleIndex + 1) % self.tentacleCount
            if self.curTentacle.currentHealth > 0 {
                return
            }
        }
    }
    
    private func startTentacleCycle() {
        self.moveToNextTentacleIndex()
        guard self.tentacleCount > 0 && self.curTentacle.currentHealth > 0 else {
            return
        }
        
        let pos = self.scene.player.position
        self.bubbleForABit(pos: pos) {
            self.spawnTentacle()
        }
    }
    
    public func bubbleForABit(pos: CGPoint, then: @escaping () -> Void) {
        self.curTentacle.setPosition(pos)
        self.curTentacle.submerge(duration: 0)
        self.curTentacle.setBubbles(true)
        self.scene.terrain.addEnemy(self.curTentacle)
        
        self.curTentacle.run(self.bubbleWait) { then() }
    }
    
    private func spawnTentacle() {
        self.curTentacle.surface()
        
        self.curTentacle.run(self.tentacleWait) {
            self.curTentacle.submerge() {
                self.scene.terrain.removeEnemy(self.curTentacle)
                self.curTentacle.setBubbles(false)
                self.startTentacleCycle()
            }
        }
    }
    
    override func onTentacleDead() {
        self.startTentacleCycle()
    }

}

class WPTTentacleWave: WPTLevelWave {
    internal let tentacleCount: Int
    internal var tentacles: [WPTLevelTentacleNode] = [WPTLevelTentacleNode]()
    internal var killedTentacles: Int = 0
    
    override init(_ waveDict: [String:AnyObject]) {
        self.tentacleCount = waveDict["tentacleCount"] as! Int
        super.init(waveDict)
    }
    
    func setup(scene: WPTLevelScene, isStatic: Bool) {
        super.setup(scene: scene)
        
        for _ in 0..<self.tentacleCount {
            let type = isStatic ? WPTTentacleEnemyType.STATIC_TENTACLE : WPTTentacleEnemyType.DYNAMIC_TENTACLE
            let tentacle = WPTLevelTentacleNode(type: type, player: scene.player, submerged: true)
            tentacle.onDeath {
                self.killedTentacles += 1
                print("\(self.tentacleCount - self.killedTentacles) tentacles left")
                self.onTentacleDead()
            }
            self.tentacles.append(tentacle)
        }
    }
    
    func onTentacleDead() {
        // override for special behavior
    }
    
    public func allTentaclesDead() -> Bool {
        for tentacle in self.tentacles {
            if tentacle.currentHealth > 0 {
                return false
            }
        }
        return true
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        return allTentaclesDead()
    }
}
