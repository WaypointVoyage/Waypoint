//
//  Values.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTValues {
    static let gameName = "Waypoint"
    static let tradeWinds = "Trade Winds"
    static let booter = "Booter - Five Zero"
    static let statFormat = "%.2f"
    static let maxAspectRatio: CGFloat = 16.0 / 9.0
    
    // values that are screen-size dependent (default values provided here, configured in initValues)
    static var screenSize = CGSize(width: 1920, height: 1080)
    static var srceenAspectRatio: CGFloat = 16.0 / 9.0
    static var usableScreenHeight: CGFloat = 1080
    static var heightShift = CGPoint.zero
    static var fontSizeTitle = CGFloat(100)
    static var fontSizeLarge = CGFloat(70)
    static var fontSizeMedium = CGFloat(50)
    static var fontSizeSmall = CGFloat(30)
    static var fontSizeTiny = CGFloat(22)
    static var fontSizeMiniscule = CGFloat(14)
    static var em = CGFloat(30)
    static var levelSceneScale: CGFloat = 1
    
    // in-game positioning and configuration
    static let actorZPosition: CGFloat = 10
    static var actorDefaultSizeScale: CGFloat = 0.3
    static let pauseShroudZPosition: CGFloat = 100
    
    // physics behavior
    static let actorMass: CGFloat = 17
    static let waterLinearDampening: CGFloat = 1.0
    static let waterAngularDampening: CGFloat = 0.9
    
    // collision bitmasks
    static let actorCbm: UInt32 = 1 << 0
    static let projectileCbm: UInt32 = 1 << 1
    static let boundaryCbm: UInt32 = 1 << 2
    static let terrainCbm: UInt32 = 1 << 3
    
    
    static func initValues(deviceScreenSize: CGSize) {
        if (deviceScreenSize.width / deviceScreenSize.height > WPTValues.maxAspectRatio) {
            print("WARNING: current screen aspect ratio is larger than the maximum supported.")
        }
        
        WPTValues.screenSize = deviceScreenSize
        WPTValues.srceenAspectRatio = screenSize.width / screenSize.height
        WPTValues.usableScreenHeight = screenSize.width / WPTValues.maxAspectRatio
        WPTValues.heightShift = CGPoint(x: 0, y: (screenSize.height - usableScreenHeight) / 2.0)
        WPTValues.levelSceneScale = usableScreenHeight / 1080.0
        
        WPTValues.fontSizeTitle = 0.25 * usableScreenHeight
        WPTValues.fontSizeLarge = 0.175 * usableScreenHeight
        WPTValues.fontSizeMedium = 0.125 * usableScreenHeight
        WPTValues.fontSizeSmall = 0.075 * usableScreenHeight
        WPTValues.fontSizeMiniscule = 0.035 * usableScreenHeight
        WPTValues.em = WPTValues.fontSizeSmall
    }
}
