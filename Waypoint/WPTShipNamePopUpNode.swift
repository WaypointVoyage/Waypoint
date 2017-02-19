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
    let startLevel = WPTLabelNode(text: "Start >", fontSize: WPTValues.fontSizeSmall)
    var inputField: UITextField?
    var randomIcon: SKSpriteNode?
    var shipPicker: WPTShipPickerNode?
    
    override init() {
        super.init()
        
        self.isUserInteractionEnabled = true
        
        let background = SKSpriteNode(imageNamed: "pause_scroll")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = WPTValues.pauseShroudZPosition + 1
        let width = 0.9 * WPTValues.screenSize.height
        let height = 0.6 * WPTValues.screenSize.height
        background.size = CGSize(width: height, height: width)
        background.zRotation = CGFloat(M_PI) / 2.0
        self.addChild(background)
        
        randomIcon = SKSpriteNode(imageNamed: "random_icon")
        randomIcon?.zPosition = WPTValues.pauseShroudZPosition + 2
        let size = CGSize(width: WPTValues.fontSizeSmall, height: WPTValues.fontSizeSmall)
        randomIcon?.size = size
        randomIcon?.position.y -= 14
        randomIcon?.position.x += 100
        self.addChild(randomIcon!)
        
        startLevel.zPosition = WPTValues.pauseShroudZPosition + 2
        startLevel.position.y -= 90
        startLevel.position.x += 80
        startLevel.alpha = 0.4
        startLevel.fontColor = UIColor.black
        self.addChild(startLevel)
        
        // exit
        shipName.zPosition = WPTValues.pauseShroudZPosition + 2
        shipName.fontColor = UIColor.black
        shipName.position.y += 0.1 * background.size.height
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
        if self.startLevel.contains(touch.location(in: self)) && self.startLevel.alpha == 1.0 {
            let shipName = self.inputField?.text
            self.inputField?.removeFromSuperview()
            let player = WPTPlayer(ship: (self.shipPicker?.currentShip)!, shipName: shipName!)
            let transition = SKTransition.reveal(with: .left, duration: 1.5)
            //(with: .left, duration: 1)
            transition.pausesOutgoingScene = true;
            transition.pausesIncomingScene = false;
            self.scene?.view?.presentScene(WPTWorldScene(player: player), transition: transition)
        }
        if (self.randomIcon?.contains(touch.location(in: self)))! {
            let plistNames = Bundle.main.path(forResource: "random_ship_names", ofType: "plist")!
            let shipNames = NSArray(contentsOfFile: plistNames) as! [String]
            let randomName = shipNames[Int(arc4random_uniform(UInt32(shipNames.count)))]
            self.inputField?.text = randomName
            self.startLevel.alpha = 1.0
        }
        self.inputField?.resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
