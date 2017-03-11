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
    let leftBorder = SKSpriteNode(imageNamed: "levelBorder")
    let rightBorder = SKSpriteNode(imageNamed: "levelBorder")
    
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
        rightFire.xScale =  -1 * self.rightBorder.xScale
        self.addChild(rightFire)
        
        self.leftBorder.position = CGPoint(x: offset*1.2, y: offset)
        self.leftBorder.size = CGSize(width: WPTValues.fontSizeLarge*2, height: WPTValues.fontSizeLarge*2)
        self.leftBorder.zPosition = WPTValues.pauseShroudZPosition + 4
        self.addChild(leftBorder)
        
        self.rightBorder.xScale =  -1 * self.rightBorder.xScale
        self.rightBorder.size = CGSize(width: WPTValues.fontSizeLarge*2, height: WPTValues.fontSizeLarge*2)
        self.rightBorder.zPosition = WPTValues.pauseShroudZPosition + 4
        self.rightBorder.position = CGPoint(x: WPTValues.screenSize.width - (offset*1.2), y: offset)
        self.addChild(rightBorder)
        
        
        
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
    
    func hideBorder() {
        self.leftFire.isHidden = true
        self.rightFire.isHidden = true
        self.leftBorder.isHidden = true
        self.rightBorder.isHidden = true
    }
    
    func displayBorder() {
        self.leftFire.isHidden = false
        self.rightFire.isHidden = false
        self.leftBorder.isHidden = false
        self.rightBorder.isHidden = false
    }
}
