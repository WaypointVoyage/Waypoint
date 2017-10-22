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
    private var retiringWakes = Set<WPTWakeNode>()
    
    init(_ terrain: WPTTerrainNode) {
        self.terrain = terrain
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        if let terrain = self.terrain {
            self.updateForActor(terrain.player, currentTime, deltaTime)
            for enemy in terrain.enemies {
                if enemy.enemy.terrainType == .sea {
                    self.updateForActor(enemy, currentTime, deltaTime)
                }
            }
        }

        for wake in self.retiringWakes {
            wake.update(currentTime, deltaTime)
            if wake.done {
                self.retiringWakes.remove(wake)
            }
        }
    }
    
    public func remove(actor: WPTLevelActorNode) {
        let wake = self.wakes.removeValue(forKey: actor)
        if let oldWake = wake {
            self.retiringWakes.insert(oldWake)
        }
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
