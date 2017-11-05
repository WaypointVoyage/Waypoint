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

class WPTAudioNode : SKNode {
    
    let audio: SKAudioNode
    init(effect: String) {
        audio = SKAudioNode(fileNamed: effect)
        super.init()
        
        audio.autoplayLooped = false
        WPTAudioConfig.audio.onEffectsVolumeChange(self.onVolumeChange)
        self.onVolumeChange(volume: WPTAudioConfig.audio.getCurrentEffectsVolume())
        self.addChild(audio)
    }
    
    private func onVolumeChange(volume: Float) {
        self.audio.run(SKAction.changeVolume(to: volume, duration: 0))
    }
    
    func playEffect(completion: (() -> Void)? = nil) {
        self.audio.run(SKAction.stop())
        self.audio.run(SKAction.play()) {
            if completion != nil {
                completion!()
            }
        }
    }
    
    func stopEffect() {
        self.audio.run(SKAction.stop())
    }
    
    func setLoop(looped: Bool) {
        self.audio.autoplayLooped = looped
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
