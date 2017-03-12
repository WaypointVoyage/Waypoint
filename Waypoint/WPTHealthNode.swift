//
//  WPTHealthNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/8/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit


class WPTHealthNode: SKNode {
    
    let healthBarWidth: CGFloat = 90
    let healthBarHeight: CGFloat = 9
    let maxHealth: CGFloat
    var curHealth: CGFloat
    
    var shipHealthBar = SKSpriteNode()
    
    init(maxHealth: CGFloat) {
        
        self.maxHealth = maxHealth
        self.curHealth = maxHealth
        
        super.init()
        
        self.addChild(shipHealthBar)
        
        updateHealthBar(maxHealth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHealth(_ healthPoints: CGFloat) -> Bool {
        self.curHealth += healthPoints
        updateHealthBar(self.curHealth)
        if (self.curHealth <= 0) {
            return false
        }
        return true
    }
    
    
    func updateHealthBar(_ currentHealth: CGFloat) {
        
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
        let barWidth = (barSize.width - 1) * CGFloat(currentHealth) / self.maxHealth
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        context!.fill(barRect)
        
        // extract image
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // set sprite texture and size
        self.shipHealthBar.texture = SKTexture(image: spriteImage!)
        self.shipHealthBar.size = barSize
    }
    
}