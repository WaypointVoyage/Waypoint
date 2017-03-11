//
//  WPTBrain.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/7/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit
import GameplayKit

class WPTBrain: GKStateMachine {
    let template: WPTBrainTemplate
    weak var enemy: WPTLevelEnemyNode! = nil
    let player: WPTLevelPlayerNode
    
    let nothingState: WPTBrainState
    let offenseState: WPTBrainState?
    let defenseState: WPTBrainState?
    let fleeState: WPTBrainState?
    
    var currentBrainState: WPTBrainState { return self.currentState as! WPTBrainState }
    
    init(_ template: WPTBrainTemplate, player: WPTLevelPlayerNode) {
        self.template = template
        self.player = player
        
        nothingState = WPTBrainStateFactory.get(template.brainStates[WPTBrainStateType.NOTHING]!)!
        if let str = template.brainStates[WPTBrainStateType.OFFENSE] {
            offenseState = WPTBrainStateFactory.get(str)
        } else { offenseState = nil }
        if let str = template.brainStates[WPTBrainStateType.DEFENSE] {
            defenseState = WPTBrainStateFactory.get(str)
        } else { defenseState = nil }
        if let str = template.brainStates[WPTBrainStateType.FLEE] {
            fleeState = WPTBrainStateFactory.get(str)
        } else { fleeState = nil }
        
        var states = [WPTBrainState]()
        states.append(nothingState)
        for state in [offenseState, defenseState, fleeState] {
            if let state = state {
                states.append(state)
            }
        }
        super.init(states: states)
    }
    
    func start() {
        let started = self.enter(WPTBrainStateFactory.classFromString(template.brainStates[WPTBrainStateType.NOTHING]!)!)
        if !started {
            NSLog("ERROR: failed to start brain: \(template.name)")
        }
    }
    
    func transition(_ type: WPTBrainStateType) -> Bool {
        guard self.currentBrainState.type != type else { return false; }
        
        switch (type) {
        case WPTBrainStateType.NOTHING:
            return self.enter(WPTBrainStateFactory.classFromInstance(self.nothingState))
        case WPTBrainStateType.OFFENSE:
            if let target = self.offenseState {
                return self.enter(WPTBrainStateFactory.classFromInstance(target))
            } else { return false; }
        case WPTBrainStateType.DEFENSE:
            if let target = self.defenseState {
                return self.enter(WPTBrainStateFactory.classFromInstance(target));
            } else { return false; }
        case WPTBrainStateType.FLEE:
            if let target = self.fleeState {
                return self.enter(WPTBrainStateFactory.classFromInstance(target));
            } else { return false; }
        }
    }
}
