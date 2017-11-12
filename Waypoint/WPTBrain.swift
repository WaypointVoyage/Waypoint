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
    static let baseRadiusOfEngagement: CGFloat = 250
    static let baseInnerRadiusOfObliviousness: CGFloat = 250
    static let baseOuterRadiusOfObliviousness: CGFloat = 250
    static let baseRadiusOfSafety: CGFloat = 250
    
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
    
    var started: Bool {
        return self.currentState != nil
    }
    
    var levelDifficulty: CGFloat {
        return (self.player.scene as? WPTLevelScene)?.level.difficulty ?? 1
    }

    var levelDifficultyTapered: CGFloat {
        if let scene = self.player.scene as? WPTLevelScene {
            return log(scene.level.difficulty) / CG_PI + 1
        }
        return 1
    }
    
    var levelDifficultySofter: CGFloat {
        let difficulty = (self.player.scene as? WPTLevelScene)?.level.difficulty ?? 1
        if difficulty <= 1 {
            return 1
        } else {
            return difficulty / 4
        }
    }
    
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
        radiusOfEngagement = enemy.enemy.haste * WPTBrain.baseRadiusOfEngagement * self.levelDifficultyTapered

        innerRadiusOfObliviousness = radiusOfEngagement + enemy.enemy.aggression * WPTBrain.baseInnerRadiusOfObliviousness * self.levelDifficultyTapered
        
        outerRadiusOfObliviousness = innerRadiusOfObliviousness + enemy.enemy.awareness * WPTBrain.baseOuterRadiusOfObliviousness * self.levelDifficultyTapered
        
        radiusOfSafety = outerRadiusOfObliviousness + enemy.enemy.caution * WPTBrain.baseRadiusOfSafety * self.levelDifficultyTapered
        
        healthCutoff = radiusOfEngagement / radiusOfSafety
        
        enemy.fireRateMgr.modifier = enemy.enemy.triggerHappiness * self.levelDifficultySofter
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
//            print("\(self.enemy.enemy.name) is entering the NOTHING state")
            return self.enter(WPTBrainStateFactory.classFromInstance(self.nothingState))
        case WPTBrainStateType.OFFENSE:
            if let target = self.offenseState {
//                print("\(self.enemy.enemy.name) is entering the OFFSENSE state")
                return self.enter(WPTBrainStateFactory.classFromInstance(target))
            } else { return false; }
        case WPTBrainStateType.DEFENSE:
            if let target = self.defenseState {
//                print("\(self.enemy.enemy.name) is entering the DEFENSE state")
                return self.enter(WPTBrainStateFactory.classFromInstance(target));
            } else { return false; }
        case WPTBrainStateType.FLEE:
            if let target = self.fleeState {
//                print("\(self.enemy.enemy.name) is entering the FLEE state")
                return self.enter(WPTBrainStateFactory.classFromInstance(target));
            } else { return false; }
        }
    }
    
    override func update(deltaTime sec: TimeInterval) {
        let healthLow = enemy.currentHealth < healthCutoff * enemy.enemy.ship.health
        let dist = CGVector(start: enemy.position, end: player.position).magnitude()
//        print("\(self.enemy.enemy.name) - {healthLow: \(healthLow), dist: \(dist), state: \(self.currentBrainState.type)}")
        self.currentBrainState.update(deltaTime: sec, healthLow: healthLow, distToPlayer: dist)

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
    }
    
    private func updateNothing(deltaTime sec: TimeInterval, dist: CGFloat, healthLow: Bool) {
        if healthLow && dist < outerRadiusOfObliviousness {
            if transition(WPTBrainStateType.FLEE) { return }
        }
        if !healthLow && dist < innerRadiusOfObliviousness {
            if transition(WPTBrainStateType.OFFENSE) { return }
        }
    }
    
    private func updateOffense(deltaTime sec: TimeInterval, dist: CGFloat, healthLow: Bool) {
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
    
    private func updateDefense(deltaTime sec: TimeInterval, dist: CGFloat, healthLow: Bool) {
        if !healthLow && dist < innerRadiusOfObliviousness {
            if transition(WPTBrainStateType.OFFENSE) { return }
        }
        if healthLow && dist > innerRadiusOfObliviousness {
            if transition(WPTBrainStateType.FLEE) { return }
        }
    }
    
    private func updateFlee(deltaTime sec: TimeInterval, dist: CGFloat, healthLow: Bool) {
        if !healthLow && dist < outerRadiusOfObliviousness {
            if transition(WPTBrainStateType.OFFENSE) { return }
        }
        if !healthLow || dist > radiusOfSafety {
            if transition(WPTBrainStateType.NOTHING) { return }
        }
    }
}
