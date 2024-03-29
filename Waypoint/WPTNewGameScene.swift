//
//  NewGameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

class WPTNewGameScene: WPTScene, UITextFieldDelegate {
    
    
    let background = WPTBackgroundNode(image: "simple_beach_scene")
    let headerLabel = WPTLabelNode(text: "New Game", fontSize: WPTValues.fontSizeLarge)
    var startLabel = WPTButtonNode(text: "Start", fontSize: WPTValues.fontSizeMedium)
    
    let healthLabel = WPTStatBarNode("Health")
    let speedLabel = WPTStatBarNode("Speed")
    let damageLabel = WPTStatBarNode("Damage")
    let rangeLabel = WPTStatBarNode("Range")
    let shotSpeedLabel = WPTStatBarNode("Shot Speed")
    
    let mapScrollEffect = WPTAudioNode(effect: "map_scroll")
    
    var shipInputField:UITextField?
    var shipPop:WPTShipNamePopUpNode?
    
    var shipPicker: WPTShipPickerNode?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        headerLabel.fontColor = UIColor.black
        addChild(headerLabel)
        
        shipPicker = WPTShipPickerNode(ships: WPTShipCatalog.playableShips, onChange: updateStats)
        shipPicker!.position = CGPoint(x: 0.3 * frame.width, y: frame.midY / 1.05)
        shipPicker!.setSize(width: 0.5 * frame.width, height: 0.6 * frame.height)
        addChild(shipPicker!)

        // ship stats
        let width: CGFloat = 0.35 * self.frame.width
        let labels = [healthLabel, damageLabel, speedLabel, rangeLabel, shotSpeedLabel]
        let spacing = WPTValues.fontSizeMiniscule + WPTStatBarNode.fontSize
        let h = CGFloat(labels.count) * spacing
        let top = self.frame.midY + (h / 2) - WPTValues.fontSizeMiniscule
        for i in 0..<labels.count {
            let label = labels[i]
            label.label.fontColor = UIColor.black
            label.position = CGPoint(x: 0.70 * self.frame.width, y: top - CGFloat(i) * spacing)
            label.setWidth(width)
            self.addChild(label)
        }
        updateStats(ship: (shipPicker?.currentShip)!)
        
        // add background
        background.position(for: self)
        addChild(background)

        startLabel.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        startLabel.label.zPosition = 2
        startLabel.background.zPosition = 1
        addChild(startLabel)
        
        self.shipPop = WPTShipNamePopUpNode()
        self.shipPop?.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.shipInputField = UITextField()
        shipInputField?.delegate = self
        shipInputField?.frame = CGRect(x: 0.79*frame.midX, y: self.shipPop!.position.y - 0.2 * self.shipPop!.background.frame.height, width: 158, height: 30)
        shipInputField?.placeholder = "Enter ship name..."
        shipInputField?.font = UIFont(name: WPTValues.booter, size: WPTValues.fontSizeTiny)
        shipInputField?.backgroundColor = UIColor.white
        shipInputField?.layer.cornerRadius = 3
        shipInputField?.layer.borderColor = (UIColor.gray).cgColor
        shipInputField?.layer.borderWidth = 1.0
        shipInputField?.textAlignment = .center
        
        self.shipPop!.setInputField(inputField: self.shipInputField!)
        self.shipPop!.setShipPicker(shipPicker: self.shipPicker!)
        
        self.addChild(mapScrollEffect)
        
        addChild(WPTHomeScene.getBack(frame: frame))
        
    
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = shipInputField?.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= WPTValues.maxShipNameLength
    }
    
    func updateStats(ship: WPTShip) {
        self.healthLabel.setStat(ship.healthScale, min: WPTShip.minHealthScale, max: 5)
        self.damageLabel.setStat(ship.damageScale, min: WPTShip.minDamageScale, max: 5)
        self.speedLabel.setStat(ship.speedScale, min: WPTShip.minSpeedScale, max: 4)
        self.rangeLabel.setStat(ship.rangeScale, min: WPTShip.minRangeScale, max: 4)
        self.shotSpeedLabel.setStat(ship.shotSpeedScale, min: WPTShip.minShotSpeedScale, max: 3)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if self.startLabel.contains(touch.location(in: self)) {
            self.view!.addSubview(shipInputField!)
            mapScrollEffect.playEffect()
            self.addChild(shipPop!)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text != "") {
            self.shipPop!.startLevel.disabled = false
        } else {
            self.shipPop!.startLevel.disabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Populates the SKLabelNode
        textField.resignFirstResponder()
        return true
    } 
}
