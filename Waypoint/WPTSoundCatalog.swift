//
//  WPTSoundCatalog.swift
//  Waypoint
//
//  Created by Hilary Schulz on 11/5/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SwiftySound

class WPTSoundCatalog {
    static let allSounds: [SoundWrapper] = {
        var sounds = [SoundWrapper]();
        
        let cannonEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "cannon.wav"))!, name: "cannon")
        let itemCollectionEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "item_collection.wav"))!, name: "item_collection")
        let anchorUpEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "anchor_up.wav"))!, name: "anchor_up")
        let bubblesEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "bubbles.wav"))!, name: "bubbles")
        let mapScrollEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "map_scroll.wav"))!, name: "map_scroll")
        let currencyEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "currency.wav"))!, name: "currency")
        let explosionEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "explosion.wav"))!, name: "explosion")
        let anchorEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "anchor.wav"))!, name: "anchor_down")
        
        sounds.append(cannonEffect)
        sounds.append(itemCollectionEffect)
        sounds.append(anchorUpEffect)
        sounds.append(bubblesEffect)
        sounds.append(mapScrollEffect)
        sounds.append(currencyEffect)
        sounds.append(explosionEffect)
        sounds.append(anchorEffect)
        
        return sounds;
    }()
    
    static let soundsByName: [String:Sound] = {
        var map = [String:Sound]();
        for sound in WPTSoundCatalog.allSounds {
            map[sound.name] = sound.sound
        }
        return map;
    }()
}

class SoundWrapper {
    var sound: Sound
    var name: String
    
    init(sound: Sound, name: String) {
        self.sound = sound
        self.name = name
    }
}
