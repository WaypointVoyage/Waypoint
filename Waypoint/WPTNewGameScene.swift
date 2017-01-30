//
//  NewGameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTNewGameScene: SKScene {
    
    let headerLabel = WPTLabelNode(text: "New Game", fontSize: fontSizeLarge)
    let startLabel = WPTLabelNode(text: "Start", fontSize: fontSizeMedium)
    let healthLabel = WPTLabelNode(text: "", fontSize: fontSizeSmall);
    let speedLabel = WPTLabelNode(text: "", fontSize: fontSizeSmall);
    let damageLabel = WPTLabelNode(text: "", fontSize: fontSizeSmall);
    let shootingLabel = WPTLabelNode(text: "", fontSize: fontSizeSmall);
    
    let ships = [WPTShip(imageName: "WaypointShip"), WPTShip(imageName: "PaperBoat"), WPTShip(imageName: "Spaceship")] // TODO: find better way to initialize ship data.
    
    override func didMove(to view: SKView) {
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        addChild(headerLabel)
        
        let shipPicker = WPTShipPickerNode(ships: ships)
        shipPicker.position = CGPoint(x: 0.35 * frame.width, y: frame.midY)
        shipPicker.setSize(width: 0.6 * frame.width, height: 0.6 * frame.height)
        addChild(shipPicker)
        
        healthLabel.text = "Health: \(shipPicker.currentShip.healthScale)"
        healthLabel.position = CGPoint(x: 0.80 * frame.width, y: 1.15 * frame.midY)
        addChild(healthLabel);
        
        damageLabel.text = "Damage: \(shipPicker.currentShip.damageScale)"
        damageLabel.position = CGPoint(x: 0.80 * frame.width, y: 1 * frame.midY)
        addChild(damageLabel)
        
        speedLabel.text = "Speed: \(shipPicker.currentShip.healthScale)mph"
        speedLabel.position = CGPoint(x: 0.80 * frame.width, y: 0.85 * frame.midY)
        addChild(speedLabel);
        
        shootingLabel.text = "Cannon Speed: \(shipPicker.currentShip.shotSpeedScale)mph"
        shootingLabel.position = CGPoint(x: 0.80 * frame.width, y: 0.7 * frame.midY)
        addChild(shootingLabel);
        
        startLabel.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        addChild(startLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
        
        
    }
}
