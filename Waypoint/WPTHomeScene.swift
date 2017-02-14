//
//  HomeScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHomeScene: WPTScene {
    
    let newGame = WPTSceneLabelNode(text: "New Game", next: WPTNewGameScene())
    let highScores = WPTSceneLabelNode(text: "High Scores", next: WPTHighScoresScene())
    let settings = WPTSceneLabelNode(text: "Settings", next: WPTSettingsScene())
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        var labels = [newGame, highScores, settings]
        let spacing = WPTValues.fontSizeMiniscule + WPTSceneLabelNode.fontSize
        let h = CGFloat(labels.count) * spacing
        let top = self.frame.midY + (h / 2) - WPTValues.fontSizeMiniscule
        for i in 0..<labels.count {
            let label = labels[i]
            label.position = CGPoint(x: self.frame.midX, y: top - CGFloat(i) * spacing)
            self.addChild(label)
        }
    }
    
    static func getBack(frame: CGRect) -> SKLabelNode {
        let back = WPTSceneLabelNode(text: "<Back", next: WPTHomeScene())
        back.position = CGPoint(x: 0.15 * frame.width, y: 0.2 * frame.height)
        return back
    }
}
