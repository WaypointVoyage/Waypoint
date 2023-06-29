//
//  WPTAudioConfig.swift
//  Waypoint
//
//  Created by Hilary Schulz on 10/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import AVFoundation
import SpriteKit

class WPTAudioConfig: NSObject, Codable {
    var backgroundMusic: AVAudioPlayer?
    var currentSong: String?
    var leftyControls: Bool? = nil
    private var currentMusicVolume: Float? = nil
    private var currentEffectsVolume: Float? = nil
    
    static var audio: WPTAudioConfig = WPTAudioConfig()
    
    // observers
    private var volumeObservers: [(Float) -> Void] = [(Float) -> Void]()
    
    private override init() {
    }
    
    public static func setInstance(_ instance: WPTAudioConfig) {
        WPTAudioConfig.audio = instance
    }
    
    public func getCurrentMusicVolume() -> Float {
        if let vol = self.currentMusicVolume {
            return vol
        }
        self.currentMusicVolume = WPTValues.defaultMusicVolume
        return WPTValues.defaultMusicVolume
    }
    
    public func getCurrentEffectsVolume() -> Float {
        if let vol = self.currentEffectsVolume {
            return vol
        }
        self.currentEffectsVolume = WPTValues.defaultEffectsVolume
        return WPTValues.defaultEffectsVolume
    }
    
    public func getLeftyControls() -> Bool {
        if let leftyControls = self.leftyControls {
            return leftyControls
        }
        self.leftyControls = WPTValues.defaultLeftyMode
        return WPTValues.defaultLeftyMode
    }
    
    func getURL(song: String) -> URL {
        let path = Bundle.main.path(forResource: song, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    func setMusicVolume(volume: Float) {
        NSLog("setting music volume: \(backgroundMusic!.volume)")
        backgroundMusic?.volume = volume
        currentMusicVolume = volume
    }
    
    func setLeftyControls() {
        self.leftyControls = !(self.leftyControls!)
    }
    
    func play() {
        backgroundMusic?.play()
    }
    
    func stop() {
        backgroundMusic?.stop()
    }
    
    func pause() {
        backgroundMusic?.pause()
    }
    
    func playSong(song: String, numLoops: Int? = -1, completion: ((Bool) -> Void)? = nil) {
        if (backgroundMusic == nil || !(backgroundMusic?.isPlaying)! || currentSong != song) {
            do {
                self.currentSong = song
                backgroundMusic = try AVAudioPlayer(contentsOf: getURL(song: song))
                backgroundMusic?.volume = getCurrentMusicVolume()
            }
            catch {
                NSLog("file '\(song)' not found")
            }
            let _ = backgroundMusic?.play(numberOfLoops: numLoops!, completion: completion)
        }
    }
    
    public func onEffectsVolumeChange(_ then: @escaping (Float) -> Void) {
        self.volumeObservers.append(then)
    }
    
    public func setEffectsVolume(_ val: Float) {
        self.currentEffectsVolume = val
        
        for action in self.volumeObservers {
            action(self.currentEffectsVolume!)
        }
    }

    enum CodingKeys: String, CodingKey {
        case leftyControls
        case currentMusicVolume
        case currentEffectsVolume
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(leftyControls, forKey: .leftyControls)
        try container.encode(currentMusicVolume, forKey: .currentMusicVolume)
        try container.encode(currentEffectsVolume, forKey: .currentEffectsVolume)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.leftyControls = try container.decode(Bool.self, forKey: .leftyControls)
        self.currentMusicVolume = try container.decodeIfPresent(Float.self, forKey: .currentMusicVolume)
        self.currentEffectsVolume = try container.decodeIfPresent(Float.self, forKey: .currentEffectsVolume)
    }
}

