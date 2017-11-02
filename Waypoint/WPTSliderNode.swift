//
//  WPTSliderNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 10/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

class WPTSliderNode: SKNode {
    
    private let background = SKSpriteNode(imageNamed: "slider_background")
    private let slider = SKSpriteNode(imageNamed: "slider")
    private let title: WPTLabelNode!
    private let progress: WPTLabelNode?
    
    private let onChange: (Float) -> Void
    
    private var val: Float
    private let minVal: Float
    private var minValXPos: CGFloat! = nil
    private let maxVal: Float
    private var maxValXPos: CGFloat! = nil
    
    var touch: UITouch? = nil

    init(title: String, min: Float, max: Float, val: Float, onChange: @escaping (Float) -> Void) {
        self.title = WPTLabelNode(text: title, fontSize: WPTValues.fontSizeSmall)
        self.progress = WPTLabelNode(text: "##%", fontSize: WPTValues.fontSizeSmall)
        self.onChange = onChange
        self.val = val
        self.minVal = min
        self.maxVal = max
        super.init()

        let backgroundSize = 0.4 * WPTValues.screenSize.width
        background.size = CGSize(width: backgroundSize, height: backgroundSize / 6.0)
        background.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self.addChild(background)

        let sliderSize = 0.08 * WPTValues.screenSize.width
        slider.size = CGSize(width: sliderSize / 1.15, height: sliderSize / 1.2)
        minValXPos = slider.size.width / 1.05
        maxValXPos = background.size.width - slider.size.width / 1.05
        
        let startX = self.getCurXPos()
        slider.position = CGPoint(x: startX, y: 0.0)
        slider.zPosition = 2.0
        self.addChild(slider)

        self.title!.fontColor = UIColor.black
        self.title!.position = CGPoint(x: -self.title!.fontSize * 1.25, y: 0.5)
        self.progress?.fontColor = UIColor.black
        self.addChild(self.title!)
        
        self.progress!.position = CGPoint(x: background.size.width + self.title!.fontSize, y: 0.5)
        self.progress?.text = "\(Int(self.getCurPercentage()))%"
        self.addChild(self.progress!)
        
        self.isUserInteractionEnabled = true
    }
    
    private func getCurPercentage() -> Float {
        return (self.val - self.minVal) / (self.maxVal - self.minVal)
    }
    
    private func getCurXPos() -> CGFloat {
        let percentage: CGFloat = CGFloat(self.getCurPercentage())
        return self.minValXPos + percentage * (self.maxValXPos - self.minValXPos)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            var touchLocation = touch.location(in: self)
            if slider.contains(touchLocation) {
                self.touch = touch
                if (touchLocation.x > maxValXPos) {
                    touchLocation.x = maxValXPos
                } else if (touchLocation.x < minValXPos) {
                    touchLocation.x = minValXPos
                }
                slider.position.x = touchLocation.x
                let newPercentage: CGFloat = (slider.position.x - self.minValXPos) / (self.maxValXPos - self.minValXPos)
                self.val = Float(self.minVal) + Float(newPercentage) * Float(self.maxVal - self.minVal)
                self.progress?.text = "\(Int(self.getCurPercentage()))%"
                onChange(self.val)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == self.touch {
                let storage = WPTStorage()
                storage.saveGlobalSettings()
            }
        }
    }
    
}
