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
    
    let ships: [WPTShip] = {
        // TODO: find better way to initialize ship data.
        var ships = [WPTShip]()
        
        let waypointShip = WPTShip(previewImage: "WaypointShip", inGameImage: "waypoint_ship_top_down")
        waypointShip.shuffleStats()
        ships.append(waypointShip)
        
        return ships
    }()
    
    var shipPicker: WPTShipPickerNode?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        addChild(headerLabel)
        
        shipPicker = WPTShipPickerNode(ships: ships, onChange: updateStats)
        shipPicker!.position = CGPoint(x: 0.25 * frame.width, y: frame.midY)
        shipPicker!.setSize(width: 0.6 * frame.width, height: 0.6 * frame.height)
        addChild(shipPicker!)

        // ship stats
        let width: CGFloat = 0.35 * self.frame.width
        var labels = [healthLabel, damageLabel, speedLabel, rangeLabel, shotSpeedLabel]
        let spacing = WPTValues.fontSizeMiniscule + WPTStatBarNode.fontSize
        let h = CGFloat(labels.count) * spacing
        let top = self.frame.midY + (h / 2) - WPTValues.fontSizeMiniscule
        for i in 0..<labels.count {
            let label = labels[i]
            label.position = CGPoint(x: 0.70 * self.frame.width, y: top - CGFloat(i) * spacing)
            label.setWidth(width)
            self.addChild(label)
        }
        updateStats(ship: (shipPicker?.currentShip)!)

        startLabel.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        addChild(startLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
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
            let player = WPTPlayer(ship: (self.shipPicker?.currentShip)!, shipName: "PLAYER_SHIP_NAME")
            
            self.view?.presentScene(WPTWorldScene(player: player))
        }
    }
}
