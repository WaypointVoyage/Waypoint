//
//  WPTTentacle1Wave.swift
//  Waypoint
//
//  Created by Hilary Schulz on 9/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 3 in the final boss
class WPTTentacle1Wave: WPTLevelWave {
    
    private var currTentacle: Tentacle? = nil
    private var prevTentacle: Tentacle? = nil
    var currLevelNode: WPTStaticTentacleNode? = nil
    var tentacleDuration: TimeInterval
    var timeCount: TimeInterval = 0.0
    var tentacleCount: Int
    
    private class Tentacle {
        
        var health: CGFloat
        var next: Tentacle! = nil
        
        init() {
            health = WPTShipCatalog.shipsByName["Tentacle"]!.health
        }
    }
    
    override init(_ waveDict: [String: AnyObject]) {
        tentacleCount = waveDict["tentacleCount"] as! Int
        tentacleDuration = waveDict["tentacleDuration"] as! TimeInterval
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        
        let head = Tentacle()
        currTentacle = head
        for _ in 0..<tentacleCount - 1 {
            let tentacleNode = Tentacle()
            self.prevTentacle = currTentacle
            self.currTentacle!.next = tentacleNode
            self.currTentacle = tentacleNode
        }
        currTentacle!.next = head
    }
    
    override func isComplete(scene: WPTLevelScene) -> Bool {
        return currTentacle == nil
    }
    
    override func update(_ deltaTime: TimeInterval) {
        timeCount += deltaTime
        if currLevelNode != nil && currLevelNode!.isDead {
            tentacleTakedown()
        }
        if (timeCount >= tentacleDuration) {
            timeCount = 0.0
            spawnTentacle()
            prevTentacle = currTentacle
            currTentacle = currTentacle?.next
        }
        
    }
    
    func spawnTentacle() {
        currLevelNode = WPTStaticTentacleNode(player: scene.player, health: currTentacle!.health)
        currLevelNode!.setUp()
        scene.terrain.addEnemy(currLevelNode)
    }
    
    func tentacleTakedown() {
        prevTentacle?.next = currTentacle?.next
        currTentacle = currTentacle?.next
    }
}

