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
        Sound.playersPerSound = 20
        let cannonEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "cannon.wav"))!, name: "cannon")
        
        Sound.playersPerSound = 4
        let coinDropEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "coin_drop.wav"))!, name: "coin_drop")
        
        Sound.playersPerSound = 4
        let gemDropEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "gem_drop.wav"))!, name: "gem_drop")
        
        Sound.playersPerSound = 4
        let pearlDropEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "pearl_drop.wav"))!, name: "pearl_drop")
        
        Sound.playersPerSound = 1
        let itemCollectionEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "item_collection.wav"))!, name: "item_collection")
        let anchorUpEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "anchor_up.wav"))!, name: "anchor_up")
        let bubblesEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "bubbles.wav"))!, name: "bubbles")
        let mapScrollEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "map_scroll.wav"))!, name: "map_scroll")
        let explosionEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "explosion.wav"))!, name: "explosion")
        let anchorEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "anchor.wav"))!, name: "anchor_down")
        let diceRollEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "dice_roll.wav"))!, name: "dice_roll")
        let whirlpoolEffect = SoundWrapper(sound: Sound(url: WPTAudioConfig.audio.getURL(song: "whirlpool.wav"))!, name: "whirlpool")
        
        sounds.append(cannonEffect)
        sounds.append(itemCollectionEffect)
        sounds.append(anchorUpEffect)
        sounds.append(bubblesEffect)
        sounds.append(mapScrollEffect)
        sounds.append(pearlDropEffect)
        sounds.append(gemDropEffect)
        sounds.append(coinDropEffect)
        sounds.append(explosionEffect)
        sounds.append(anchorEffect)
        sounds.append(diceRollEffect)
        sounds.append(whirlpoolEffect)
        
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
