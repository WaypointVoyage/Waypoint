//
//  WPTAudioEffects.swift
//  Waypoint
//
//  Created by Hilary Schulz on 10/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTAudioEffects {
    
    public private(set) var volume: Float = WPTValues.initialVolume
    
    public static let instance = WPTAudioEffects()
    private init() {
        // singleton
    }
    
    // observers
    private var volumeObservers: [(Float) -> Void] = [(Float) -> Void]()
    public func onVolumeChange(_ then: @escaping (Float) -> Void) {
        self.volumeObservers.append(then)
    }
    
    public func setVolume(_ val: Float) {
        self.volume = val
        
        for action in self.volumeObservers {
            action(self.volume)
        }
    }
}
