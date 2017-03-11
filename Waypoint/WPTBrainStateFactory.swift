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
            
        default:
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
        print("string: \(string)")
        return classFromString(string)!
    }
}
