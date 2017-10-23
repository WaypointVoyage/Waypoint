//
//  WPTAudioMusic.swift
//  Waypoint
//
//  Created by Hilary Schulz on 10/14/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import AVFoundation

class WPTAudioMusic {
    
    var backgroundMusic: AVAudioPlayer?
    var currentSong: String?
    var currentVolume: Float? = 0.0
    
    private init() {
    }
    
    static let music: WPTAudioMusic = WPTAudioMusic()
    
    func getURL(song: String) -> URL {
        self.currentSong = song
        let path = Bundle.main.path(forResource: song, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    func play() {
        backgroundMusic?.play()
    }
    
    func changeVolume(volume: Float) {
        print(backgroundMusic!.volume)
        backgroundMusic?.volume = volume
        currentVolume = volume
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
                backgroundMusic?.volume = currentVolume!
            }
            catch {
                print("file not found")
            }
            backgroundMusic?.numberOfLoops = -1
            play()
        }
    }
}
