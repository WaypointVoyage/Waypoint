//
//  WPTBrainState.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTBrainState: GKState {
    let name: String
    let type: WPTBrainStateType
    
    var brain: WPTBrain { return self.stateMachine as! WPTBrain }
    
    var enemy: WPTLevelEnemyNode {
        return (self.stateMachine as! WPTBrain).enemy
    }
    
    var player: WPTLevelPlayerNode {
        return (self.stateMachine as! WPTBrain).player
    } 
    
    init(name: String, type: WPTBrainStateType) {
        self.name = name
        self.type = type
    }
    
    func tryShoot() {
        guard enemy.fireRateMgr.canFire else { return; }
        
        for cannon in self.enemy.cannonNodes {
            let rot = enemy.zRotation + cannon.zRotation
            let dir = CGPoint(x: cos(rot), y: sin(rot))
            let toPlayer = CGVector(dx: player.position.x - enemy.position.x, dy: player.position.y - enemy.position.y).normalized()
            if dir.toVector().dot(toPlayer) >= 0 {
                let line = WPTLine(p: enemy.position, q: enemy.position + dir)
                let circle = WPTCircle(center: player.position, radius: player.sprite.frame.size.width / 2)
                if line.intersects(circle: circle) {
                    self.enemy.fireCannons()
                    break
                }
            }
        }
    }
    
    func aimAtPlayer() {
        let toPlayer = CGVector(start: enemy.position, end: player.position)
        
        var closestCannon: WPTCannonNode? = nil
        var bestDot: CGFloat? = nil
        for cannon in enemy.cannonNodes {
            let angle = enemy.zRotation + cannon.zRotation
            let forward = CGVector(dx: cos(angle), dy: sin(angle))
            let dot = forward.dot(toPlayer)
            if closestCannon == nil || dot > bestDot! {
                closestCannon = cannon
                bestDot = dot
            }
        }
        
        if let cannon = closestCannon {
            enemy.targetRot = toPlayer.angle() - cannon.zRotation
        }
    }
}

enum WPTBrainStateType: String {
    case NOTHING = "_NOTHING"
    case OFFENSE = "_OFFENSE"
    case DEFENSE = "_DEFENSE"
    case FLEE = "_FLEE"
}