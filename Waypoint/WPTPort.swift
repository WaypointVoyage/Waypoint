//
//  WPTPort.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/3/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPort {
    
    let position: CGPoint
    let angle: CGFloat
    
    var inventory = [(item: String, price: CGFloat, inStock: Bool)]()
    
    // loading from plist
    init(_ portDict: [String:AnyObject]) {
        let posDict = portDict["position"] as! [String:CGFloat]
        position = CGPoint(x: posDict["x"]!, y: posDict["y"]!)
        angle = posDict["angle"]!
        
        for good in portDict["inventory"] as! [[String:AnyObject]] {
            let item = good["item"] as! String
            let price = good["price"] as! CGFloat
            let inStock = good["inStock"] as! Bool
            inventory.append((item: item, price: price, inStock: inStock))
        }
    }
}
