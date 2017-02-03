//
//  NewGameScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTNewGameScene: WPTScene {
    
    let headerLabel = WPTLabelNode(text: "New Game", fontSize: fontSizeLarge)
    let startLabel = WPTLabelNode(text: "Start", fontSize: fontSizeMedium)
    let healthLabel = WPTLabelNode(text: "", fontSize: fontSizeSmall);
    let speedLabel = WPTLabelNode(text: "", fontSize: fontSizeSmall);
    let damageLabel = WPTLabelNode(text: "", fontSize: fontSizeSmall);
    let shootingLabel = WPTLabelNode(text: "", fontSize: fontSizeSmall);
    
    let ships = [WPTShip(imageName: "WaypointShip"), WPTShip(imageName: "PaperBoat"), WPTShip(imageName: "Spaceship")] // TODO: find better way to initialize ship data.
    var shipPicker: WPTShipPickerNode?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        addChild(headerLabel)
        
        /* TESTING SHIP VALUES */
        for ship in ships {
            ship.initStats(speedScale: randStat(), damageScale: randStat(), healthScale: randStat(), rangeScale: randStat(), shotSpeedScale: randStat());
        }
        
        shipPicker = WPTShipPickerNode(ships: ships, onChange: updateStats)
        shipPicker?.position = CGPoint(x: 0.35 * frame.width, y: frame.midY)
        shipPicker?.setSize(width: 0.6 * frame.width, height: 0.6 * frame.height)
        addChild(shipPicker!)

        /* ship stats */
        position(label: self.healthLabel, at: 1.15 * self.frame.midY)
        position(label: self.damageLabel, at: 1 * self.frame.midY)
        position(label: self.speedLabel, at: 0.85 * self.frame.midY)
        position(label: self.shootingLabel, at: 0.7 * self.frame.midY)
        updateStats(ship: (shipPicker?.currentShip)!)

        startLabel.position = CGPoint(x: frame.midX, y: 0.1 * frame.height)
        addChild(startLabel)
        addChild(WPTHomeScene.getBack(frame: frame))
    }
    
    func position(label: SKLabelNode, at height: CGFloat) {
        label.position = CGPoint(x: 0.65 * self.frame.width, y: height)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addChild(label)
    }
    
    func updateStats(ship: WPTShip) {
        self.healthLabel.text = "Health: " + String(format: statFormat, ship.healthScale)
        self.damageLabel.text = "Damage: " + String(format: statFormat, ship.damageScale)
        self.speedLabel.text = "Speed: " + String(format: statFormat, ship.speedScale) + " mph"
        self.shootingLabel.text = "Cannon Speed: " + String(format: statFormat, ship.shotSpeedScale) + " mph"
    }
    
    func randStat() -> Double {
        return (Double(arc4random()) / Double(UInt32.max)) * 2 - 1
    }
    
}
