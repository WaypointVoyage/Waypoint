//
//  WPTShipNamePopUp.swift
//  Waypoint
//
//  Created by Hilary Schulz on 2/17/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

class WPTShipNamePopUpNode: SKNode {
    
    let shipName = WPTLabelNode(text: "Ship Name", fontSize: WPTValues.fontSizeSmall)
    let startLevel = WPTButtonNode(text: "Start >", fontSize: WPTValues.fontSizeSmall)
    let background = SKSpriteNode(imageNamed: "pause_scroll")
    var inputField: UITextField?
    var randomIcon: SKSpriteNode?
    var shipPicker: WPTShipPickerNode?
    
    var pauseShroud: SKShapeNode
    
    override init() {
        self.pauseShroud = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: WPTValues.screenSize))
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        // shroud
        self.pauseShroud.fillColor = UIColor.black
        self.pauseShroud.strokeColor = UIColor.black
        self.pauseShroud.position = CGPoint(x: -WPTValues.screenSize.width/2, y: -WPTValues.screenSize.height/2)
        self.pauseShroud.zPosition = WPTZPositions.shrouds
        self.pauseShroud.alpha = 0.6
        self.addChild(pauseShroud)

        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = self.pauseShroud.zPosition + 1
        let width = 0.9 * WPTValues.screenSize.height
        let height = 0.6 * WPTValues.screenSize.height
        background.size = CGSize(width: height, height: width)
        background.zRotation = CG_PI / 2.0
        self.addChild(background)
        
        randomIcon = SKSpriteNode(imageNamed: "random_icon")
        randomIcon!.zPosition = background.zPosition + 1
        let size = CGSize(width: WPTValues.fontSizeSmall, height: WPTValues.fontSizeSmall)
        randomIcon?.size = size
        randomIcon?.position.y = 0.135 * background.frame.height
        randomIcon?.position.x += 100
        self.addChild(randomIcon!)
        
        startLevel.zPosition = background.zPosition + 1
        startLevel.position.y -= 73
        startLevel.position.x += 88
        startLevel.disabled = true
        self.addChild(startLevel)
        
        shipName.zPosition = background.zPosition + 1
        shipName.fontColor = UIColor.black
        shipName.position.y += 0.23 * background.size.height
        self.addChild(shipName)
    }
    
    func setInputField(inputField: UITextField) {
        self.inputField = inputField
    }
    
    func setShipPicker(shipPicker: WPTShipPickerNode) {
        self.shipPicker = shipPicker
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        self.inputField?.resignFirstResponder()
        if self.startLevel.contains(touch.location(in: self)) && self.startLevel.disabled == false {
            
            let shipName = self.inputField?.text
            self.inputField?.removeFromSuperview()
            let ship = WPTShip(other: self.shipPicker!.currentShip)
            let player = WPTPlayer(ship: ship, shipName: shipName!)
            
            // wipe the old save with the new one
            let storage = WPTStorage()
            storage.savePlayerProgress(player.progress!)
            
            // the transition
            if WPTConfig.values.testing {
                self.scene!.view!.presentScene(WPTWorldScene(player: player))
            } else {
                let transition = SKTransition.reveal(with: .left, duration: 1.5)
                transition.pausesOutgoingScene = true;
                transition.pausesIncomingScene = false;
                self.scene!.view!.presentScene(WPTWorldScene(player: player), transition: transition)
            }
        }
        else if (self.randomIcon?.contains(touch.location(in: self)))! {
            let plistNames = Bundle.main.path(forResource: "random_ship_names", ofType: "plist")!
            let shipNames = NSArray(contentsOfFile: plistNames) as! [String]
            let randomName = shipNames[Int(arc4random_uniform(UInt32(shipNames.count)))]
            self.inputField?.text = randomName
            self.startLevel.disabled = false
        }
        else if !self.background.contains(touch.location(in: self)) {
            self.inputField?.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
