//
//  WPTWakeManager.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/12/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTWakeManager: WPTUpdatable {
    
    private weak var terrain: WPTTerrainNode?
    private var wakes = [WPTLevelActorNode:WPTWakeNode]()
    
    init(_ terrain: WPTTerrainNode) {
        self.terrain = terrain
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        if let terrain = self.terrain {
            self.updateForActor(terrain.player, currentTime, deltaTime)
            for enemy in terrain.enemies {
                if enemy.enemy.terrainType != .land {
                    self.updateForActor(enemy, currentTime, deltaTime)
                }
            }
        }
    }
    
    public func remove(actor: WPTLevelActorNode) {
        // TODO: maintain existing wakes when removed, right now, they just stay frozen
        self.wakes.removeValue(forKey: actor)
    }
    
    private func updateForActor(_ actor: WPTLevelActorNode, _ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        // get the wake (or make one)
        var wake: WPTWakeNode? = self.wakes[actor]
        if wake == nil {
            wake = WPTWakeNode(actor)
            self.wakes[actor] = wake
            self.terrain?.addChild(wake!)
        }
        
        // update the wake
        wake!.update(currentTime, deltaTime)
    }
}
