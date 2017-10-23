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
    
    let background = SKSpriteNode(imageNamed: "slider_background")
    let slider = SKSpriteNode(imageNamed: "slider")
    let title: WPTLabelNode!
    let progress: WPTLabelNode?
    var minVal: CGFloat! = nil
    var maxVal: CGFloat! = nil

    init(title: String, progress: String) {
        self.title = WPTLabelNode(text: title, fontSize: WPTValues.fontSizeSmall)
        self.progress = WPTLabelNode(text: "\(WPTValues.initialVolume)%", fontSize: WPTValues.fontSizeSmall)
        super.init()

        let backgroundSize = 0.4 * WPTValues.screenSize.width
        background.size = CGSize(width: backgroundSize, height: backgroundSize / 6.0)
        background.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self.addChild(background)


        let sliderSize = 0.08 * WPTValues.screenSize.width
        slider.size = CGSize(width: sliderSize / 1.15, height: sliderSize / 1.2)
        minVal = slider.size.width / 1.05
        maxVal = background.size.width - slider.size.width / 1.05
        
        slider.position = CGPoint(x: minVal, y: 0.0)
        slider.zPosition = 2.0
        self.addChild(slider)

        self.title!.fontColor = UIColor.black
        self.title!.position = CGPoint(x: -self.title!.fontSize * 1.25, y: 0.5)
        self.progress?.fontColor = UIColor.black
        self.addChild(self.title!)
        
        self.progress!.position = CGPoint(x: background.size.width + self.title!.fontSize, y: 0.5)
        self.addChild(self.progress!)
        
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            var touchLocation = touch.location(in: self)
            if slider.contains(touchLocation) {
                if (touchLocation.x > maxVal) {
                    touchLocation.x = maxVal
                } else if (touchLocation.x < minVal) {
                    touchLocation.x = minVal
                }
                slider.position.x = (touchLocation.x)
                progress?.text = getPercent(touchLocation.x)
            }
        }
    }
    
    func getPercent(_ x: CGFloat) -> String {
        let progressVal = (x - minVal) * 100.0/(maxVal - minVal)
        if title.text == "Music" {
            WPTAudioMusic.music.changeVolume(volume: Float(progressVal))
        } else {
            WPTAudioEffects.instance.setVolume(Float(progressVal))
        }
        return String("\(Int(progressVal))%")
    }
}
