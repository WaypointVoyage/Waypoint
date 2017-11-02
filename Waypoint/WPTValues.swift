//
//  Values.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTValues {
    
    // Metadata
    static let gameName = "Waypoint"
    static let tradeWinds = "Trade Winds"
    static let booter = "Booter - Five Zero"
    static let statFormat = "%.2f"
    static let maxAspectRatio: CGFloat = 16.0 / 9.0
    static let maxHighScores: Int = 25
    
    // values that are screen-size dependent (default values provided here, configured in initValues)
    static var screenSize = CGSize(width: 1920, height: 1080)
    static var srceenAspectRatio: CGFloat = 16.0 / 9.0
    static var usableScreenHeight: CGFloat = 1080
    static var heightShift = CGPoint.zero
    static var fontSizeMassive = CGFloat(200)
    static var fontSizeTitle = CGFloat(100)
    static var fontSizeLarge = CGFloat(70)
    static var fontSizeMedium = CGFloat(50)
    static var fontSizeKindaSmall = CGFloat(40)
    static var fontSizeSmall = CGFloat(30)
    static var fontSizeTiny = CGFloat(22)
    static var fontSizeMiniscule = CGFloat(14)
    static var em = CGFloat(30)
    static var levelSceneScale: CGFloat = 1
    static var actorDefaultSizeScale: CGFloat = 0.3
    
    // physics behavior
    static let actorBaseMass: CGFloat = 17
    static let waterLinearDampening: CGFloat = 1.0
    static let waterAngularDampening: CGFloat = 0.9
    
    // team bitmasks
    static let playerTbm: UInt32 = 1 << 0
    static let enemyTbm: UInt32 = 1 << 1
    
    // collision bitmasks
    static let actorCbm: UInt32 = 1 << 0
    static let projectileCbm: UInt32 = 1 << 1
    static let boundaryCbm: UInt32 = 1 << 2
    static let terrainCbm: UInt32 = 1 << 3
    static let whirlpoolCbm: UInt32 = 1 << 4
    static let boulderCbm: UInt32 = 1 << 5
    static let itemCbm: UInt32 = 1 << 6
    static let dockCbm: UInt32 = 1 << 7
    static let itemCollectionCbm: UInt32 = 1 << 8
    static let damageActorCbm: UInt32 = 1 << 9
    
    // level bahaviors
    static let playerPrepTime: TimeInterval = 4
    
    static let defaultMusicVolume: Float = 5.0
    static let defaultEffectsVolume: Float = 5.0
    static let defaultLeftyMode: Bool = false
    
    static let maxShipNameLength = 22
    
    static func initValues(deviceScreenSize: CGSize) {
        let ar = deviceScreenSize.width / deviceScreenSize.height
        if (ar > WPTValues.maxAspectRatio) {
            print("WARNING: current screen aspect ratio (\(ar)) is larger than the maximum supported.")
        }
        
        WPTValues.screenSize = deviceScreenSize
        WPTValues.srceenAspectRatio = screenSize.width / screenSize.height
        WPTValues.usableScreenHeight = screenSize.width / WPTValues.maxAspectRatio
        WPTValues.heightShift = CGPoint(x: 0, y: (screenSize.height - usableScreenHeight) / 2.0)
        WPTValues.levelSceneScale = usableScreenHeight / 1080.0
        
        WPTValues.fontSizeMassive = 0.5 * usableScreenHeight
        WPTValues.fontSizeTitle = 0.25 * usableScreenHeight
        WPTValues.fontSizeLarge = 0.175 * usableScreenHeight
        WPTValues.fontSizeMedium = 0.125 * usableScreenHeight
        WPTValues.fontSizeKindaSmall = 0.1 * usableScreenHeight
        WPTValues.fontSizeSmall = 0.075 * usableScreenHeight
        WPTValues.fontSizeMiniscule = 0.035 * usableScreenHeight
        WPTValues.em = WPTValues.fontSizeSmall
    }
}

class WPTZPositions {
    static let water: CGFloat = 0
    static let terrain: CGFloat = 10
    static let actors: CGFloat = 100
    static let hud: CGFloat = 200
    static let touchHandler: CGFloat = 250
    static let shrouds: CGFloat = 500
}
