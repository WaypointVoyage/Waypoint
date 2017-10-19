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
    private var curTentacleIndex: Int = -1
    private var curTentacle: WPTLevelEnemyNode {
        return self.tentacles[self.curTentacleIndex]
    }
    
    private var bubbles: WPTBubbleSurfaceNode? = nil
    private let bubbleDuraiton: TimeInterval
    
    override init(_ waveDict: [String:AnyObject]) {
        self.bubbleDuraiton = waveDict["bubbleDuration"] as! TimeInterval
        self.tentacleDuration = waveDict["tentacleDuration"] as! TimeInterval
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
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
            print("NO MORE TENTACLES")
            return
        }
        print("Next tentacle")
        
        let pos = self.scene.player.position
        self.bubbleForABit(pos: pos) {
            self.spawnTentacle()
        }
    }
    
    public func bubbleForABit(pos: CGPoint, then: @escaping () -> Void) {
        self.bubbles = self.makeTentacleBubbles()
        self.bubbles!.position = pos
        bubbles!.start()
        bubbles!.run(SKAction.wait(forDuration: self.bubbleDuraiton)) {
            self.curTentacle.position = pos
            self.scene.terrain.addEnemy(self.curTentacle)
            then()
        }
    }
    
    private func spawnTentacle() {
        self.curTentacle.run(SKAction.wait(forDuration: self.tentacleDuration)) {
            self.scene.terrain.removeEnemy(self.curTentacle)
            self.restartTentacleCycle()
        }
    }
    
    private func restartTentacleCycle() {
        self.bubbles?.removeFromParent()
        self.bubbles = nil
        self.startTentacleCycle()
    }
    
    override func onTentacleDead() {
        self.restartTentacleCycle()
    }

}

class WPTTentacleWave: WPTLevelWave {
    internal let tentacleCount: Int
    internal let tentacleEnemy: WPTEnemy = WPTEnemyCatalog.enemiesByName["Static Tentacle"]!
    internal var tentacles: [WPTLevelEnemyNode] = [WPTLevelEnemyNode]()
    internal var killedTentacles: Int = 0
    
    override init(_ waveDict: [String:AnyObject]) {
        self.tentacleCount = waveDict["tentacleCount"] as! Int
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        
        for _ in 0..<self.tentacleCount {
            
            // TODO: finish making the tentacle enemy...
            
            // TODO: find out why tentacles start to teleport after a while
            
            let tentacle = WPTLevelEnemyNode(enemy: self.tentacleEnemy, player: scene.player)
            tentacle.onDeath {
                self.killedTentacles += 1
                print("\(self.tentacleCount - self.killedTentacles) tentacles left!")
                self.onTentacleDead()
            }
            self.tentacles.append(tentacle)
        }
    }
    
    func makeTentacleBubbles() -> WPTBubbleSurfaceNode {
        let bubbles = WPTBubbleSurfaceNode(width: 100, height: 100)
        self.scene.terrain.addChild(bubbles)
        return bubbles
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
