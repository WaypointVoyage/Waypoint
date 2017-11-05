//
//  WPTAudioNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 10/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import SwiftySound

class WPTAudioNode : SKNode {
    
    let audio: Sound
    init(effect: String) {
        audio = WPTSoundCatalog.soundsByName[effect]!
        super.init()
        
//        audio.autoplayLooped = false
        WPTAudioConfig.audio.onEffectsVolumeChange(self.onVolumeChange)
        self.onVolumeChange(volume: WPTAudioConfig.audio.getCurrentEffectsVolume())
//        self.addChild(audio)
    }
    
    private func onVolumeChange(volume: Float) {
//        self.audio.run(SKAction.changeVolume(to: volume, duration: 0))
        audio.volume = volume
    }
    
    func playEffect() {
        self.audio.stop()
        self.audio.play(numberOfLoops: 0)
        
    }
    
    func stopEffect() {
        self.audio.stop()
    }
    
    func setLoop(looped: Bool) {
//        self.audio.autoplayLooped = looped
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
