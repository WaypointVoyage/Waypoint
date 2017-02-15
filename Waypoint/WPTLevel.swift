//
//  WPTLevel.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/13/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTLevel {
    
    let name: String
    
    init(_ levelFileNamed: String?) {
        let lfn = levelFileNamed == nil ? "NOTAREAL" : levelFileNamed
        if let plistPath = Bundle.main.path(forResource: lfn, ofType: "plist") {
            
            let levelDict = NSDictionary(contentsOfFile: plistPath) as! [String: AnyObject]
            self.name = levelDict["name"] as! String
            
        } else {
            
            self.name = "LEVEL NAME"
            
        }
    }
}
