//
//  WPTShip.swift
//  Waypoint
//
//  Created by Hilary Schulz on 1/26/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTShip {
    
    let name: String
    let playable: Bool
    
    /* All stats are multipliers of base values and clamped between min/max values. */
    
    var speedScale: CGFloat = 1.0 { // determines the speed of the ship as it moves
        didSet { clamp(&speedScale, min: WPTShip.minSpeedScale, max: WPTShip.maxSpeedScale) }
    }
    var speed: CGFloat {
        get { return speedScale * WPTShip.baseSpeed }
    }
    
    var damageScale: CGFloat = 1.0 { // determines the amount of damage that the ship does
        didSet { clamp(&damageScale, min: WPTShip.minDamageScale, max: WPTShip.maxDamageScale) }
    }
    var damage: CGFloat {
        get { return damageScale * WPTShip.baseDamage }
    }
    
    var healthScale: CGFloat = 1.0 { // determines the amount of health on the ship
        didSet { clamp(&healthScale, min: WPTShip.minHealthScale, max: WPTShip.maxHealthScale) }
    }
    var health: CGFloat {
        get { return healthScale * WPTShip.baseHealth }
    }
    
    var rangeScale: CGFloat = 1.0 { // determines how far cannon shots travel before hitting the water/ground
        didSet { clamp(&rangeScale, min: WPTShip.minRangeScale, max: WPTShip.maxRangeScale) }
    }
    var range: CGFloat {
        get { return rangeScale * WPTShip.baseRange }
    }
    
    var shotSpeedScale: CGFloat = 1.0 { // determines how fast cannon shots travel through the air
        didSet { clamp(&shotSpeedScale, min: WPTShip.minShotSpeedScale, max: WPTShip.maxShotSpeedScale) }
    }
    var shotSpeed: CGFloat {
        get { return shotSpeedScale * WPTShip.baseShotSpeed }
    }
    
    var sizeScale: CGFloat = 1.0 { // determines the size of the ship on the screen
        didSet { clamp(&sizeScale, min: WPTShip.minSizeScale, max: WPTShip.maxSizeScale) }
    }
    var size: CGFloat {
        get { return sizeScale * WPTShip.baseSize }
    }
    
    var turnRateScale: CGFloat = 1.0 { // determines how quickly the ship makes turns
        didSet { clamp(&turnRateScale, min: WPTShip.minTurnRateScale, max: WPTShip.maxTurnRateScale) }
    }
    var turnRate: CGFloat {
        get { return turnRateScale * WPTShip.baseTurnRate }
    }
    
    var fireRateScale: CGFloat = 1.0 { // determines how many shots/second can be made
        didSet { clamp(&fireRateScale, min: WPTShip.minFireRateScale, max: WPTShip.maxFireRateScale) }
    }
    var fireRate: CGFloat {
        get { return fireRateScale * WPTShip.baseFireRate }
    }
    
    let previewImage: String
    let inGameImage: String
    let cannonSet: WPTCannonSet
    let colliderPath: CGPath
    
    init(dict: [String:AnyObject], playable: Bool) {
        self.playable = playable
        
        self.name = dict["name"] as! String
        self.previewImage = dict["previewImage"] as! String
        self.inGameImage = dict["inGameImage"] as! String
        self.cannonSet = WPTCannonSet(dict["cannonSet"] as! [[String:AnyObject]])
        
        // collider
        let pathArr = dict["colliderPath"] as! [[CGFloat]]
        let offsetDict = dict["colliderOffset"] as! [String:CGFloat]
        let path = CGMutablePath()
        if pathArr.count > 0 {
            let offset = CGPoint(x: offsetDict["x"]!, y: offsetDict["y"]!)
            path.move(to: CGPoint(x: 2 * pathArr[0][0], y: 2 * pathArr[0][1]) + offset)
            for i in 1..<pathArr.count {
                let point = pathArr[i]
                path.addLine(to: CGPoint(x: 2 * point[0], y: 2 * point[1]) + offset)
            }
            path.closeSubpath()
        }
        colliderPath = path
        
        // stats
        if let stats = dict["stats"] as? [String:CGFloat] {
            self.speedScale = stats["speedScale"]!
            self.damageScale = stats["damageScale"]!
            self.healthScale = stats["healthScale"]!
            self.rangeScale = stats["rangeScale"]!
            self.shotSpeedScale = stats["shotSpeedScale"]!
            self.sizeScale = stats["sizeScale"]!
            self.turnRateScale = stats["turnRateScale"]!
            self.fireRateScale = stats["fireRateScale"]!
        }
        else if let stats = dict["stats"] as? String {
            if stats == "max" {
                self.speedScale = WPTShip.maxSpeedScale
                self.damageScale = WPTShip.maxDamageScale
                self.healthScale = WPTShip.maxHealthScale
                self.rangeScale = WPTShip.maxRangeScale
                self.shotSpeedScale = WPTShip.maxShotSpeedScale
                self.sizeScale = WPTShip.maxSizeScale
                self.turnRateScale = WPTShip.maxTurnRateScale
                self.fireRateScale = WPTShip.maxFireRateScale
            }
            else if stats == "min" {
                self.speedScale = WPTShip.minSpeedScale
                self.damageScale = WPTShip.minDamageScale
                self.healthScale = WPTShip.minHealthScale
                self.rangeScale = WPTShip.minRangeScale
                self.shotSpeedScale = WPTShip.minShotSpeedScale
                self.sizeScale = WPTShip.minSizeScale
                self.turnRateScale = WPTShip.minTurnRateScale
                self.fireRateScale = WPTShip.minFireRateScale
            }
        }
    }
    
    init(other: WPTShip) {
        self.name = other.name
        self.playable = other.playable
        self.previewImage = other.previewImage
        self.inGameImage = other.inGameImage
        self.cannonSet = WPTCannonSet(other: other.cannonSet)
        self.colliderPath = other.colliderPath
        self.initStats(speedScale: other.speedScale, damageScale: other.damageScale, healthScale: other.healthScale, rangeScale: other.rangeScale, shotSpeedScale: other.shotSpeedScale, sizeScale: other.sizeScale, turnRateScale: other.turnRateScale)
    }
    
    func initStats(speedScale: CGFloat = 1.0, damageScale: CGFloat = 1.0, healthScale: CGFloat = 1.0, rangeScale: CGFloat = 1.0, shotSpeedScale: CGFloat = 1.0, sizeScale: CGFloat = 1.0, turnRateScale: CGFloat = 1.0, fireRateScale: CGFloat = 1.0) {
        self.speedScale = speedScale
        self.damageScale = damageScale
        self.healthScale = healthScale
        self.rangeScale = rangeScale
        self.shotSpeedScale = shotSpeedScale
        self.sizeScale = sizeScale
        self.turnRateScale = turnRateScale
        self.fireRateScale = fireRateScale
    }
    
    func shuffleStats() {
        self.speedScale = WPTShip.randStat(min: WPTShip.minSpeedScale, max: WPTShip.maxSpeedScale)
        self.damageScale = WPTShip.randStat(min: WPTShip.minDamageScale, max: WPTShip.maxDamageScale)
        self.healthScale = WPTShip.randStat(min: WPTShip.minHealthScale, max: WPTShip.maxHealthScale)
        self.rangeScale = WPTShip.randStat(min: WPTShip.minRangeScale, max: WPTShip.maxRangeScale)
        self.shotSpeedScale = WPTShip.randStat(min: WPTShip.minShotSpeedScale, max: WPTShip.maxShotSpeedScale)
        self.sizeScale = WPTShip.randStat(min: WPTShip.minSizeScale, max: WPTShip.maxSizeScale)
        self.turnRateScale = WPTShip.randStat(min: WPTShip.minTurnRateScale, max: WPTShip.maxTurnRateScale)
        self.fireRateScale = WPTShip.randStat(min: WPTShip.minFireRateScale, max: WPTShip.maxFireRateScale)
    }
    
    static func randStat(min: CGFloat, max: CGFloat) -> CGFloat {
        let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return (max - min) * rand + min
    }
    
    func upgrade(with item: WPTItem) {
        self.speedScale += item.speedModifier ?? 0
        self.damageScale += item.damageModifier ?? 0
        self.healthScale += item.healthModifier ?? 0
        self.rangeScale += item.rangeModifier ?? 0
        self.shotSpeedScale += item.shotSpeedModifier ?? 0
        self.sizeScale += item.sizeModifier ?? 0
        self.turnRateScale += item.turnRateModifier ?? 0
        self.fireRateScale += item.fireRateModifier ?? 0
    }
}

extension WPTShip {
    static let minSpeedScale: CGFloat = 0.4
    static let maxSpeedScale: CGFloat = 10.0
    static let baseSpeed: CGFloat = 3500.0
    
    static let minDamageScale: CGFloat = 0.5
    static let maxDamageScale: CGFloat = 20.0
    static let baseDamage: CGFloat = 20.0
    
    static let minHealthScale: CGFloat = 0.5
    static let maxHealthScale: CGFloat = 50.0
    static let baseHealth: CGFloat = 100
    
    static let minRangeScale: CGFloat = 0.2
    static let maxRangeScale: CGFloat = 50.0
    static let baseRange: CGFloat = 350
    
    static let minShotSpeedScale: CGFloat = 0.1
    static let maxShotSpeedScale: CGFloat = 5.0
    static let baseShotSpeed: CGFloat = 1000.0
    
    static let minSizeScale: CGFloat = 0.5
    static let maxSizeScale: CGFloat = 2.5
    static let baseSize: CGFloat = 0.3
    
    static let minTurnRateScale: CGFloat = 0.4
    static let maxTurnRateScale: CGFloat = 10
    static let baseTurnRate: CGFloat = 1.0
    
    static let minFireRateScale: CGFloat = 0.2
    static let maxFireRateScale: CGFloat = 10
    static let baseFireRate: CGFloat = 2
}
