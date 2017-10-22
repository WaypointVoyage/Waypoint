//
//  WPTScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/2/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTScene: SKScene {
    
    var aspectRatio: CGFloat = 1.0
    
    func getSong() -> String {
        return "main_menu_theme.MP3"
    }
    
    override func didMove(to view: SKView) {
        
        WPTAudioMusic.music.playSong(song: getSong())
        self.scaleMode = SKSceneScaleMode.resizeFill
        self.size = view.frame.size
        
        self.aspectRatio = self.size.width / self.size.height
    }

}
