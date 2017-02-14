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
    
    let ships: [WPTShip]
    var shipTextures = [SKTexture]()
    var index = 0
    
    var onChange: (WPTShip) -> Void
    
    let leftArrow = SKSpriteNode(imageNamed: "chevron")
    let rightArrow = SKSpriteNode(imageNamed: "chevron")
    var shipImage = SKSpriteNode(imageNamed: "box")
    
    var width: CGFloat?
    var height: CGFloat?
    
    var currentShip: WPTShip {
        get {
            return ships[index]
        }
    }
    
    var currentShipTexture: SKTexture {
        get{
            return shipTextures[index]
        }
    }
    
    init(ships: [WPTShip], onChange: @escaping (WPTShip) -> Void) {
        self.ships = ships
        self.onChange = onChange
        super.init()
        assert(self.ships.count >= 1, "At least one ship is required!")
        isUserInteractionEnabled = true
        
        // setup the arrows
        rightArrow.zRotation = CGFloat.pi
        let arrowSize = 0.08 * WPTValues.screenSize.width
        leftArrow.size = CGSize(width: arrowSize, height: arrowSize)
        rightArrow.size = leftArrow.size
        leftArrow.anchorPoint = CGPoint(x: -1, y: 0.5)
        rightArrow.anchorPoint = CGPoint(x: -1, y: 0.5)
        addChild(leftArrow)
        addChild(rightArrow)
        
        // setup the ship image
        for ship in self.ships {
            shipTextures.append(SKTexture(imageNamed: ship.imageName))
        }
        shipImage.texture = currentShipTexture
        shipImage.position = CGPoint.zero
        let shipImgSize = 0.2 * WPTValues.screenSize.width
        shipImage.size = CGSize(width: shipImgSize, height: shipImgSize)
        addChild(shipImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSize(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        
        leftArrow.position = CGPoint(x: -width / 2, y: 0)
        rightArrow.position = CGPoint(x: width / 2, y: 0)
        shipImage.size = CGSize(width: 0.6 * height, height: 0.6 * height)
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
        shipImage.texture = currentShipTexture
        self.onChange(self.currentShip)
    }
}
