//
//  WPTSettingsScene.swift
//  Waypoint
//
//  Created by Hilary Schulz on 1/26/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTSettingsScene: WPTScene {
    
    let background = WPTBackgroundNode(image: "simple_beach_scene")
    let headerLabel = WPTLabelNode(text: "Settings", fontSize: WPTValues.fontSizeLarge)
    var effectSlider: WPTSliderNode!
    var musicSlider: WPTSliderNode!
    var leftySwitch: WPTSwitchNode!
    
    override func didMove(to view: SKView) {
        
        effectSlider = WPTSliderNode(title: "Effects", min: 0, max: 10, val: WPTAudioConfig.audio.getCurrentEffectsVolume(), onChange: WPTAudioConfig.audio.setEffectsVolume)
        musicSlider = WPTSliderNode(title: "Music", min: 0, max: 10, val: WPTAudioConfig.audio.getCurrentMusicVolume(), onChange: WPTAudioConfig.audio.setMusicVolume)
        leftySwitch = WPTSwitchNode(title: "Lefty Mode", switchValue: WPTAudioConfig.audio.getLeftyControls(), onChange: WPTAudioConfig.audio.setLeftyControls)
        
        super.didMove(to: view)
        
        headerLabel.position = CGPoint(x: frame.midX, y: 0.85 * frame.height)
        headerLabel.fontColor = UIColor.black
        addChild(headerLabel)
        
        addChild(WPTHomeScene.getBack(frame: frame))
        
        // add background
        background.position(for: self)
        addChild(background)
        
        effectSlider.position = CGPoint(x: 0.3 * frame.width, y: frame.midY / 0.75)
        musicSlider.position = CGPoint(x: 0.3 * frame.width, y: frame.midY / 1.10)
        leftySwitch.position = CGPoint(x: 0.5 * frame.width, y: frame.midY / 1.90)
        
        addChild(effectSlider)
        addChild(musicSlider)
        addChild(leftySwitch)
    }
}
