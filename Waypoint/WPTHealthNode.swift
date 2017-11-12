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
    var maxHealth: CGFloat
    var curHealth: CGFloat
    
    var shipHealthBar = SKSpriteNode()
    let persistent: Bool
    
    init(maxHealth: CGFloat, curHealth: CGFloat, persistent: Bool) {
        self.persistent = persistent
        self.maxHealth = maxHealth
        self.curHealth = curHealth
        
        super.init()
        self.zPosition = 10
        
        self.addChild(shipHealthBar)
        
        if !persistent {
            shipHealthBar.isHidden = true
            shipHealthBar.alpha = 0
        }
        
        updateHealthBar(self.curHealth, flash: false)
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
    
    func updateHealthBar(_ currentHealth: CGFloat, flash: Bool = true) {
        let barSize = CGSize(width: healthBarWidth, height: healthBarHeight);
        
        var fillColor: UIColor! = nil
        let healthProp = currentHealth / maxHealth
        if healthProp > 0.5 {
            fillColor = UIColor(red: 51.0/255, green: 255.0/255, blue: 51.0/255, alpha:1)
        } else if healthProp > 0.25 {
            fillColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1)
        } else {
            fillColor = UIColor(red: 1.0, green: 0.2, blue: 0.0, alpha: 1)
        }
        let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        // create drawing context
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // draw the health bar with a colored rectangle
        fillColor.setFill()
        let barWidth = (barSize.width - 1) * CGFloat(currentHealth) / self.maxHealth
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        context!.fill(barRect)
        
        // draw the outline for the health bar
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPoint(x: 0, y: 0), size: barSize)
        context!.stroke(borderRect, width: 5)
        
        // extract image
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // set sprite texture and size
        self.shipHealthBar.texture = SKTexture(image: spriteImage!)
        self.shipHealthBar.size = barSize
        
        // flash the health bar
        if flash && !persistent {
            shipHealthBar.removeAllActions()
            shipHealthBar.isHidden = false
            shipHealthBar.alpha = 1.0
            shipHealthBar.run(SKAction.wait(forDuration: 1.4)) {
                self.shipHealthBar.run(SKAction.fadeOut(withDuration: 0.4)) {
                    self.shipHealthBar.isHidden = true
                    self.shipHealthBar.alpha = 0
                }
            }
        }
    }
    
}
