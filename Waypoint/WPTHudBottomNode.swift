//
//  WPTHudBottomNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHudBottomNode: SKNode {
    private let leftFire: WPTFireButtonNode
    private let rightFire: WPTFireButtonNode
    
    private var pressed: Bool = false
    
    var onStartPress: (() -> Void)?
    var onEndPress: (() -> Void)?
    
    override init() {
        self.leftFire = WPTFireButtonNode()
        self.rightFire = WPTFireButtonNode()
        super.init()
        self.isUserInteractionEnabled = true
        
        let offset = WPTValues.fontSizeMedium / 2 + WPTValues.fontSizeMiniscule
        leftFire.position = CGPoint(x: offset, y: offset)
        self.addChild(leftFire)
        
        rightFire.position = CGPoint(x: WPTValues.screenSize.width - offset, y: offset)
        self.addChild(rightFire)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !pressed {
            let location = touches.first!.location(in: self)
            if self.leftFire.contains(location) || self.rightFire.contains(location) {
                self.leftFire.startPress()
                self.rightFire.startPress()
                self.pressed = true
                self.onStartPress?()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pressed {
            self.leftFire.endPress()
            self.rightFire.endPress()
            self.pressed = false
            self.onEndPress?()
        }
    }
}
