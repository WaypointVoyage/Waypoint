//
//  WPTHealthBarNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 2/20/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit


class WPTHealthBarNode: SKNode {
    
    let healthBarWidth: CGFloat = 90
    let healthBarHeight: CGFloat = 9

    let player: WPTPlayer
    
    var shipImage: SKSpriteNode
    var shipHealthBar = SKSpriteNode()
    
    init(player: WPTPlayer) {
        self.player = player
        
        self.shipImage = SKSpriteNode(imageNamed: player.ship.previewImage)
        self.shipImage.zPosition = WPTValues.movementHandlerZPosition - 1
        let shipImgSize = 1.15 * WPTValues.fontSizeSmall
        let shipOffset = 1.4 * shipImgSize
        self.shipImage.position = CGPoint(x: shipOffset, y: WPTValues.screenSize.height - shipOffset)
        self.shipImage.size = CGSize(width: shipImgSize, height: shipImgSize)
        
        self.shipHealthBar.zPosition = WPTValues.movementHandlerZPosition - 1
        self.shipHealthBar.position = CGPoint(x: shipOffset * 2.5, y: WPTValues.screenSize.height - shipOffset * 1.1)
        
        super.init()
        
        self.addChild(shipImage)
        self.addChild(shipHealthBar)
        
        updateHealthBar(node: self.shipHealthBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func updateHealthBar(node: SKSpriteNode) {
        
        let barSize = CGSize(width: healthBarWidth, height: healthBarHeight);
        
        let fillColor = UIColor(red: 51.0/255, green: 255.0/255, blue: 51.0/255, alpha:1)
        let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        // create drawing context
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // draw the outline for the health bar
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPoint(x: 0, y: 0), size: barSize)
        context!.stroke(borderRect, width: 1)
        
        // draw the health bar with a colored rectangle
        fillColor.setFill()
        let barWidth = (barSize.width - 1) * CGFloat(player.health) / WPTValues.maxHealth
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        context!.fill(barRect)
        
        // extract image
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // set sprite texture and size
        node.texture = SKTexture(image: spriteImage!)
        node.size = barSize
    }

}
