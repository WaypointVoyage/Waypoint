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
        
        WPTAudioConfig.audio.onEffectsVolumeChange(self.onVolumeChange)
        self.onVolumeChange(volume: WPTAudioConfig.audio.getCurrentEffectsVolume())
    }
    
    private func onVolumeChange(volume: Float) {
        audio.volume = volume
    }
    
    func playEffect() {
        self.audio.play(numberOfLoops: 0)
        
    }
    
    func stopEffect() {
        self.audio.stop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
