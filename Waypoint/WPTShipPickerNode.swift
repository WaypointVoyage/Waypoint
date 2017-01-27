//
//  WPTShipPickerNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/26/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

class WPTShipPickerNode: SKNode {
    let ARROW_SIZE = 40
    
    let ships: [WPTShip]
    var index = 0
    
    let leftArrow = SKSpriteNode(imageNamed: "chevron")
    let rightArrow = SKSpriteNode(imageNamed: "chevron")
    
    var width: CGFloat?
    var height: CGFloat?
    
    init(ships: [WPTShip]) {
        self.ships = ships
        super.init()
        assert(self.ships.count >= 1, "At least one ship is required!")
        
        isUserInteractionEnabled = true
        
        leftArrow.name = "leftArrow"
        rightArrow.name = "rightArrow"
        
        rightArrow.zRotation = CGFloat.pi
        leftArrow.size = CGSize(width: ARROW_SIZE, height: ARROW_SIZE)
        rightArrow.size = leftArrow.size
        
        leftArrow.anchorPoint = CGPoint(x: 0, y: 0.5)
        rightArrow.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        addChild(leftArrow)
        addChild(rightArrow)
        
        leftArrow.zPosition = 5
        rightArrow.zPosition = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentShip: WPTShip {
        get {
            return ships[index]
        }
    }
    
    func setSize(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        
        leftArrow.position = CGPoint(x: -width / 2, y: 0)
        rightArrow.position = CGPoint(x: width / 2, y: 0)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        var offset = 0
        if leftArrow.contains(touch.location(in: self)) {
            offset = -1
        } else if rightArrow.contains(touch.location(in: self)) {
            offset = 1
        } else {
            return
        }
        
        // update the current ship index, rotating to other end of the array
        index = (index + offset) % ships.count
        if index < 0 { // so the % operator in swift is stupid.... -1 % 3 = -1. Not 2
            index += ships.count
        }
    }
}
