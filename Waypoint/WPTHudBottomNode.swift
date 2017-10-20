//
//  WPTHudBottomNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHudBottomNode: SKNode, WPTUpdatable {
    private let leftFire: WPTFireButtonNode
    private let rightFire: WPTFireButtonNode
    private let leftAnchor: WPTAnchorButtonNode
    private let rightAnchor: WPTAnchorButtonNode
    let alert = WPTAlertNode()
    
    private var pressed: Bool = false
    private var anchored: Bool = true
    
    override init() {
        self.leftFire = WPTFireButtonNode()
        self.rightFire = WPTFireButtonNode()
        self.leftAnchor = WPTAnchorButtonNode()
        self.rightAnchor = WPTAnchorButtonNode()
        super.init()
        self.isUserInteractionEnabled = true
        
        let offset = WPTValues.fontSizeMedium / 1.24 + WPTValues.fontSizeMiniscule
        leftFire.position = CGPoint(x: offset, y: offset)
        leftAnchor.position = CGPoint(x: offset * 2.5, y: offset * 0.8)
        self.addChild(leftFire)
        self.addChild(leftAnchor)
        
        rightFire.position = CGPoint(x: WPTValues.screenSize.width - offset, y: offset)
        rightAnchor.position = CGPoint(x: WPTValues.screenSize.width - offset * 2.5, y: offset * 0.8)
        rightFire.xScale =  -1 * self.leftFire.xScale
        self.addChild(rightFire)
        self.addChild(rightAnchor)
        
        alert.position = CGPoint(x: WPTValues.screenSize.width * 0.5, y: 10)
        self.addChild(alert)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        // continuously try to fire the cannons when pressed
        if pressed {
            if let player = (self.scene as? WPTLevelScene)?.player {
                player.fireCannons()
            }
        }
        if let player = (self.scene as? WPTLevelScene)?.player {
            if player.anchored {
                self.leftAnchor.startPress()
                self.rightAnchor.startPress()
            } else {
                self.leftAnchor.endPress()
                self.rightAnchor.endPress()
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if !pressed {
            if self.leftFire.contains(location) || self.rightFire.contains(location) {
                self.leftFire.startPress()
                self.rightFire.startPress()
                self.pressed = true
            }
        }
        if self.leftAnchor.contains(location) || self.rightAnchor.contains(location) {
            if let player = (self.scene as? WPTLevelScene)?.player {
                if player.interactionEnabled {
                    player.anchored = !player.anchored
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pressed {
            self.leftFire.endPress()
            self.rightFire.endPress()
            self.pressed = false
        }
    }
    
    func hideBorder() {
        self.leftFire.isHidden = true
        self.rightFire.isHidden = true
        self.leftAnchor.isHidden = true
        self.rightAnchor.isHidden = true
    }
    
    func displayBorder() {
        self.leftFire.isHidden = false
        self.rightFire.isHidden = false
        self.leftAnchor.isHidden = false
        self.rightAnchor.isHidden = false
    }
}
