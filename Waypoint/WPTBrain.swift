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
    // these stack onto eachother, see the state diagram for clarification
    static let baseRadiusOfEngagement: CGFloat = 300
    static let baseInnerRadiusOfObliviousness: CGFloat = 300
    static let baseOuterRadiusOfObliviousness: CGFloat = 300
    static let baseRadiusOfSafety: CGFloat = 300
    
    let template: WPTBrainTemplate
    weak var enemy: WPTLevelEnemyNode! = nil
    let player: WPTLevelPlayerNode
    
    let nothingState: WPTBrainState
    let offenseState: WPTBrainState?
    let defenseState: WPTBrainState?
    let fleeState: WPTBrainState?
    
    var currentBrainState: WPTBrainState { return self.currentState as! WPTBrainState }
    
    var radiusOfEngagement: CGFloat! = nil
    var innerRadiusOfObliviousness: CGFloat! = nil
    var outerRadiusOfObliviousness: CGFloat! = nil
    var radiusOfSafety: CGFloat! = nil
    var healthCutoff: CGFloat! = nil
    
    init(_ template: WPTBrainTemplate, player: WPTLevelPlayerNode) {
        self.template = template
        self.player = player
        
        // set states
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
    
    func setBehavior() {
        radiusOfEngagement = enemy.enemy.haste * WPTBrain.baseRadiusOfEngagement
        innerRadiusOfObliviousness = radiusOfEngagement + enemy.enemy.aggression * WPTBrain.baseInnerRadiusOfObliviousness
        outerRadiusOfObliviousness = innerRadiusOfObliviousness + enemy.enemy.awareness * WPTBrain.baseOuterRadiusOfObliviousness
        radiusOfSafety = outerRadiusOfObliviousness + enemy.enemy.caution * WPTBrain.baseRadiusOfSafety
        healthCutoff = radiusOfEngagement / radiusOfSafety
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
//            print("transitioning to nothing")
            return self.enter(WPTBrainStateFactory.classFromInstance(self.nothingState))
        case WPTBrainStateType.OFFENSE:
            if let target = self.offenseState {
//                print("transitioning to offense")
                return self.enter(WPTBrainStateFactory.classFromInstance(target))
            } else { return false; }
        case WPTBrainStateType.DEFENSE:
            if let target = self.defenseState {
//                print("transitioning to defense")
                return self.enter(WPTBrainStateFactory.classFromInstance(target));
            } else { return false; }
        case WPTBrainStateType.FLEE:
            if let target = self.fleeState {
//                print("transitioning to flee")
                return self.enter(WPTBrainStateFactory.classFromInstance(target));
            } else { return false; }
        }
    }
    
    override func update(deltaTime sec: TimeInterval) {
        if let curState = self.currentState {
            curState.update(deltaTime: sec)
        }
        
        let healthLow = enemy.currentHealth < healthCutoff * enemy.enemy.ship.health
        let dist = CGVector(dx: player.position.x - enemy.position.x, dy: player.position.y - enemy.position.y).magnitude()
        
        // new state?
        switch (currentBrainState.type) {
        case WPTBrainStateType.NOTHING:
            updateNothing(deltaTime: sec, dist: dist, healthLow: healthLow)
        case WPTBrainStateType.OFFENSE:
            updateOffense(deltaTime: sec, dist: dist, healthLow: healthLow)
        case WPTBrainStateType.DEFENSE:
            updateDefense(deltaTime: sec, dist: dist, healthLow: healthLow)
        case WPTBrainStateType.FLEE:
            updateFlee(deltaTime: sec, dist: dist, healthLow: healthLow)
        }
//        print("current state: \(self.currentBrainState.type)")
    }
    
    func updateNothing(deltaTime sec: TimeInterval, dist: CGFloat, healthLow: Bool) {
        if healthLow && dist < outerRadiusOfObliviousness {
            if transition(WPTBrainStateType.FLEE) { return }
        }
        if !healthLow && dist < innerRadiusOfObliviousness {
            if transition(WPTBrainStateType.OFFENSE) { return }
        }
    }
    
    func updateOffense(deltaTime sec: TimeInterval, dist: CGFloat, healthLow: Bool) {
        if healthLow && dist < radiusOfEngagement {
            if transition(WPTBrainStateType.DEFENSE) { return }
        }
        if healthLow && dist < outerRadiusOfObliviousness {
            if transition(WPTBrainStateType.FLEE) { return }
        }
        if dist > outerRadiusOfObliviousness {
            if transition(WPTBrainStateType.NOTHING) { return }
        }
    }
    
    func updateDefense(deltaTime sec: TimeInterval, dist: CGFloat, healthLow: Bool) {
        if !healthLow && dist < innerRadiusOfObliviousness {
            if transition(WPTBrainStateType.OFFENSE) { return }
        }
        if healthLow && dist > innerRadiusOfObliviousness {
            if transition(WPTBrainStateType.FLEE) { return }
        }
    }
    
    func updateFlee(deltaTime sec: TimeInterval, dist: CGFloat, healthLow: Bool) {
        if !healthLow && dist < outerRadiusOfObliviousness {
            if transition(WPTBrainStateType.OFFENSE) { return }
        }
        if !healthLow || dist > radiusOfSafety {
            if transition(WPTBrainStateType.NOTHING) { return }
        }
    }
}
