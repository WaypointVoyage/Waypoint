//
//  WPTBrainStateFactory.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTBrainStateFactory {
    static func get(_ state: String) -> WPTBrainState? {
        switch (state) {
            
        case String(describing: WPTStandAndShootBS.self):
            return WPTStandAndShootBS()
            
        case String(describing: WPTDoNothingBS.self):
            return WPTDoNothingBS()
            
        case String(describing: WPTPursueBS.self):
            return WPTPursueBS()
            
        case String(describing: WPTFleeBS.self):
            return WPTFleeBS()
            
        case String(describing: WPTFleeOffenseBS.self):
            return WPTFleeOffenseBS()
            
        case String(describing: WPTWanderBS.self):
            return WPTWanderBS()
            
        case String(describing: WPTTentacleWanderBS.self):
            return WPTTentacleWanderBS()
            
        case String(describing: WPTFaceRandomDirectionsBS.self):
            return WPTFaceRandomDirectionsBS()
            
        case String(describing: WPTWiggleBS.self):
            return WPTWiggleBS()
            
        case String(describing: WPTTentacleAttackBS.self):
            return WPTTentacleAttackBS()
            
        default:
            if !state.isEmpty {
                print("WARNING: unknown brain state: \(state), Perhaps it was just added? If so, create a new WPTBrainStateFactory.get case!!!")
            }
            return nil
        }
    }
    
    static func classFromString(_ className: String?) -> AnyClass? {
        guard let className = className else { return nil }
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
        let cls: AnyClass? = NSClassFromString("\(namespace).\(className)");
        return cls;
    }
    
    static func classFromInstance(_ instance: WPTBrainState) -> AnyClass {
        let string = String(describing: type(of: instance))
        return classFromString(string)!
    }
}
