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
    
    let shipPicker = WPTShipPickerNode(ships: [WPTShip(imageName: "WaypointShip"), WPTShip(imageName: "PaperBoat"), WPTShip(imageName: "Spaceship")]) // TODO: find better way to initialize ship data.
    
    override func didMove(to view: SKView) {
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        addChild(headerLabel)
        
        shipPicker.position = CGPoint(x: 0.35 * frame.width, y: frame.midY)
        shipPicker.setSize(width: 0.6 * frame.width, height: 0.6 * frame.height)
        addChild(shipPicker)
        
        startLabel.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        addChild(startLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
    }
}
