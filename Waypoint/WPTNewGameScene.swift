//
//  NewGameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTNewGameScene: WPTScene {
    
    let headerLabel = WPTLabelNode(text: "New Game", fontSize: WPTValues.fontSizeLarge)
    var startLabel = WPTLabelNode(text: "Start", fontSize: WPTValues.fontSizeMedium)
    
    let healthLabel = WPTStatBarNode("Health")
    let speedLabel = WPTStatBarNode("Speed")
    let damageLabel = WPTStatBarNode("Damage")
    let rangeLabel = WPTStatBarNode("Range")
    let shotSpeedLabel = WPTStatBarNode("Shot Speed")
    
    let ships = [WPTShip(imageName: "WaypointShip"), WPTShip(imageName: "PaperBoat"), WPTShip(imageName: "Spaceship")] // TODO: find better way to initialize ship data.
    var shipPicker: WPTShipPickerNode?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        addChild(headerLabel)
        
        /* TESTING SHIP VALUES */
        for ship in ships {
            ship.shuffleStats()
        }
        
        shipPicker = WPTShipPickerNode(ships: ships, onChange: updateStats)
        shipPicker!.position = CGPoint(x: 0.25 * frame.width, y: frame.midY)
        shipPicker!.setSize(width: 0.55 * frame.width, height: 0.6 * frame.height)
        addChild(shipPicker!)

        /* ship stats */
        let width: CGFloat = 0.35 * self.frame.width
        position(label: self.healthLabel, width: width, at: 1.15 * self.frame.midY)
        position(label: self.damageLabel, width: width, at: 1.0 * self.frame.midY)
        position(label: self.speedLabel, width: width, at: 0.85 * self.frame.midY)
        position(label: self.rangeLabel, width: width, at: 0.7 * self.frame.midY)
        position(label: self.shotSpeedLabel, width: width, at: 0.55 * self.frame.midY)
        updateStats(ship: (shipPicker?.currentShip)!)

        startLabel.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        addChild(startLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
    }
    
    func position(label: WPTStatBarNode, width: CGFloat, at height: CGFloat) {
        label.position = CGPoint(x: 0.70 * self.frame.width, y: height)
        label.setWidth(width)
        addChild(label)
    }
    
    func updateStats(ship: WPTShip) {
        self.healthLabel.setStat(ship.healthScale, min: WPTShip.minHealthScale, max: WPTShip.maxHealthScale)
        self.damageLabel.setStat(ship.damageScale, min: WPTShip.minDamageScale, max: WPTShip.maxDamageScale)
        self.speedLabel.setStat(ship.speedScale, min: WPTShip.minSpeedScale, max: WPTShip.maxSpeedScale)
        self.rangeLabel.setStat(ship.rangeScale, min: WPTShip.minRangeScale, max: WPTShip.maxRangeScale)
        self.shotSpeedLabel.setStat(ship.shotSpeedScale, min: WPTShip.minShotSpeedScale, max: WPTShip.maxShotSpeedScale)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if self.startLabel.contains(touch.location(in: self)) {
            // TODO: get the ship's name
            let player = WPTPlayer(shipName: "PLAYER_SHIP_NAME", ship: (self.shipPicker?.currentShip)!)
            
            self.view?.presentScene(WPTWorldScene(player: player))
        }
    }
}
