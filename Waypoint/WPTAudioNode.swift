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
    
    private let maxSounds: Int?
    private var numPlaying: Int = 0

    init(effect: String, maxSounds: Int? = nil) {
        self.maxSounds = maxSounds
        audio = WPTSoundCatalog.soundsByName[effect]!
        super.init()
        
        WPTAudioConfig.audio.onEffectsVolumeChange(self.onVolumeChange)
        self.onVolumeChange(volume: WPTAudioConfig.audio.getCurrentEffectsVolume())
    }
    
    private func onVolumeChange(volume: Float) {
        audio.volume = volume
    }
    
    func playEffect() {
        guard WPTAudioConfig.audio.getCurrentEffectsVolume() > 0.01 else { return }
        if self.maxSounds == nil || self.numPlaying < self.maxSounds! {
            self.numPlaying += 1
            OperationQueue().addOperation {
                self.audio.play(numberOfLoops: 0) { (played: Bool) in
                    self.numPlaying = max(0, self.numPlaying - 1)
                }
            }
        }
    }
    
    func stopEffect() {
        self.numPlaying = max(0, self.numPlaying - 1)
        self.audio.stop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
