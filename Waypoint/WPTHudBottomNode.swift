//
//  WPTHudBottomNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHudBottomNode: SKNode, WPTUpdatable {
    
    public let fire: WPTFireButtonNode
    public let anchor: WPTAnchorButtonNode
    public let wheel: WPTShipWheelNode
    
    let alert = WPTAlertNode()
    
    private var pressed: Bool = false
    private var anchored: Bool = true
    
    init(leftMode: Bool) {
        self.wheel = WPTShipWheelNode()
        
        self.fire = WPTFireButtonNode()
        self.anchor = WPTAnchorButtonNode()
        super.init()
        self.isUserInteractionEnabled = true
        
        self.addChild(self.wheel)
        self.addChild(fire)
        self.addChild(anchor)
        
        let offset: CGFloat = WPTValues.fontSizeMedium / 1.24 + WPTValues.fontSizeMiniscule
        if leftMode {
            self.setupLeftHanded(offset)
        } else {
            self.setupRightHanded(offset)
        }
        
        alert.position = CGPoint(x: WPTValues.screenSize.width * 0.5, y: 10)
        self.addChild(alert)
    }
    
    private static let anchorXOffsetScale: CGFloat = 2.5
    private static let anchorYOffsetScale: CGFloat = 0.8
    
    private static let wheelXOffsetScale: CGFloat = 1.6
    private static let wheelYOffsetScale: CGFloat = 1.6
    
    private func setupRightHanded(_ offset: CGFloat) {
        self.fire.position = CGPoint(x: WPTValues.screenSize.width - offset, y: offset)
        self.fire.xScale = -1
        self.anchor.position = CGPoint(x: WPTValues.screenSize.width - offset * WPTHudBottomNode.anchorXOffsetScale, y: offset * WPTHudBottomNode.anchorYOffsetScale)
        self.wheel.position = CGPoint(x: offset * WPTHudBottomNode.wheelXOffsetScale, y: offset * WPTHudBottomNode.wheelYOffsetScale)
    }
    
    private func setupLeftHanded(_ offset: CGFloat) {
        self.fire.position = CGPoint(x: offset, y: offset)
        self.fire.xScale = 1
        self.anchor.position = CGPoint(x: offset * WPTHudBottomNode.anchorXOffsetScale, y: offset * WPTHudBottomNode.anchorYOffsetScale)
        self.wheel.position = CGPoint(x: WPTValues.screenSize.width - offset * WPTHudBottomNode.wheelXOffsetScale, y: offset * WPTHudBottomNode.wheelYOffsetScale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ currentTime: TimeInterval, _ deltaTime: TimeInterval) {
        
        self.wheel.update(currentTime, deltaTime)
        
        // continuously try to fire the cannons when pressed
        if pressed {
            if let player = (self.scene as? WPTLevelScene)?.player {
                player.fireCannons()
            }
        }
        if let player = (self.scene as? WPTLevelScene)?.player {
            if player.anchored {
                self.anchor.startPress()
            } else {
                self.anchor.endPress()
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if !pressed {
            if self.fire.contains(location) {
                self.fire.startPress()
                self.pressed = true
                return
            }
        }
        
        if self.anchor.contains(location) {
            if let player = (self.scene as? WPTLevelScene)?.player {
                if player.interactionEnabled {
                    player.anchorEffect.playEffect()
                    if (player.portHandler.docked) {
                        player.anchored = false
                        player.portHandler.undock()
                    } else {
                        player.anchored = !player.anchored
                    }
                }
                
            }
            return
        }
        
        if self.wheel.contains(location) {
            self.wheel.setTouch(touches.first!)
            return
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.wheel.getTouch() == touches.first! {
            self.wheel.setTouch(nil)
        }
        
        if pressed {
            self.fire.endPress()
            self.pressed = false
        }
    }
    
    func hideBorder() {
        self.fire.isHidden = true
        self.anchor.isHidden = true
    }
    
    func displayBorder() {
        self.fire.isHidden = false
        self.anchor.isHidden = false
    }
}
