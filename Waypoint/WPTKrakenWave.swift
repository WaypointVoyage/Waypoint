//
//  WPTKrakenWave.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/22/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

// wave 5 in the final boss
class WPTKrakenWave: WPTLevelWave {
    
    private var kraken: WPTLevelEnemyNode! = nil
    private let krakenLocation: CGPoint
    private let bubbleDuration: TimeInterval
    private var krakenIsDead: Bool = false
    
    override init(_ waveDict: [String: AnyObject]) {
        let krakenLocationDict = waveDict["krakenLocation"] as! [String:CGFloat]
        self.krakenLocation = CGPoint(x: krakenLocationDict["x"]!, y: krakenLocationDict["y"]!)
        self.bubbleDuration = waveDict["bubbleDuration"] as! TimeInterval
        super.init(waveDict)
    }
    
    override func setup(scene: WPTLevelScene) {
        super.setup(scene: scene)
        self.spawnKraken()
    }
    
    private func spawnKraken() {
        self.kraken = WPTLevelEnemyNode(enemy: WPTEnemyCatalog.enemiesByName["Kraken"]!, player: self.scene.player)
        self.kraken.position = self.krakenLocation
        self.kraken.onDeath {
            self.krakenIsDead = true
        }
        
        let bubbles = WPTBubbleSurfaceNode(width: 1000, height: 600)
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
        return self.krakenIsDead
    }
}
