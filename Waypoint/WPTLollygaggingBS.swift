//
//  WPTLollygaggingBS.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/21/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLollygaggingBS: WPTBrainState {
    static let type: WPTBrainStateType = WPTBrainStateType.NOTHING
    
    private var lollygagging = false
    private var timeLollygagging: TimeInterval = 0
    private var maxTimeLollygagging: TimeInterval = 2
    
    init(name: String) {
        super.init(name: name, type: WPTLollygaggingBS.type)
    }
    
    override func update(deltaTime sec: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {
        self.update(deltaTime: sec)
        
        if lollygagging {
            timeLollygagging += sec
            if timeLollygagging > maxTimeLollygagging {
                self.stopLollygagging()
            }
        } else {
            if self.needNewObjective() {
                self.setObjective()
            }
            
            self.updateWithObjective(deltaTime: sec, healthLow: healthLow, distToPlayer: distToPlayer)
            
            if self.objectiveSatisfied() {
                self.startLollygagging()
            }
        }
    }
    
    func startLollygagging() {
        self.lollygagging = true
        self.timeLollygagging = 0
        self.removeObjective()
        self.onStartLollygagging()
    }
    
    func stopLollygagging() {
        self.lollygagging = false
        self.removeObjective()
        self.onStopLollygagging()
    }
    
    // override in child classes
    func needNewObjective() -> Bool { return false }
    func setObjective() {}
    func removeObjective() {}
    func objectiveSatisfied() -> Bool { return false }
    func updateWithObjective(deltaTime sec: TimeInterval, healthLow: Bool, distToPlayer: CGFloat) {}
    func onStartLollygagging() {}
    func onStopLollygagging() {}
}
