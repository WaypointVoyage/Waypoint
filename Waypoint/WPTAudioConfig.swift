//
//  WPTAudioConfig.swift
//  Waypoint
//
//  Created by Hilary Schulz on 10/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import AVFoundation

class WPTAudioConfig: NSObject, NSCoding {
    
    var backgroundMusic: AVAudioPlayer?
    var currentSong: String?
    private var currentMusicVolume: Float? = nil
    private var currentEffectsVolume: Float? = nil
    
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
    
    static var audio: WPTAudioConfig = WPTAudioConfig()
    
    func getURL(song: String) -> URL {
        self.currentSong = song
        let path = Bundle.main.path(forResource: song, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    func play() {
        backgroundMusic?.play()
    }
    
    func setMusicVolume(volume: Float) {
        print(backgroundMusic!.volume)
        backgroundMusic?.volume = volume
        currentMusicVolume = volume
    }
    
    func stop() {
        backgroundMusic?.stop()
    }
    
    func pause() {
        backgroundMusic?.pause()
    }
    
    func playSong(song: String) {
        if (backgroundMusic == nil || !(backgroundMusic?.isPlaying)! || currentSong != song) {
            do {
                backgroundMusic = try AVAudioPlayer(contentsOf: getURL(song: song))
                backgroundMusic?.volume = getCurrentMusicVolume()
            }
            catch {
                print("file not found")
            }
            backgroundMusic?.numberOfLoops = -1
            play()
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.currentMusicVolume, forKey: "musicVolume")
        aCoder.encode(self.currentEffectsVolume, forKey: "effectsVolume")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.currentMusicVolume = aDecoder.decodeObject(forKey: "musicVolume") as? Float
        self.currentEffectsVolume = aDecoder.decodeObject(forKey: "effectsVolume") as? Float
    }
}

