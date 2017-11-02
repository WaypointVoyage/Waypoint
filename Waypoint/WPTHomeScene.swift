//
//  HomeScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 1/23/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTHomeScene: WPTScene {
    
    let background = WPTBackgroundNode(image: "beach_scene")
    let title = WPTLabelNode(text: "Waypoint", fontSize: WPTValues.fontSizeMedium)
    let treasureChest = SKSpriteNode(imageNamed: "treasure_filled")
    let newGame = WPTSceneLabelNode(text: "New Game", next: WPTNewGameScene())
    var continueLbl: WPTSceneLabelNode?
    let highScores = WPTSceneLabelNode(text: "High Scores", next: WPTHighScoresScene())
    let settings = WPTSceneLabelNode(text: "Settings", next: WPTSettingsScene())
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // is there saved data?
        let storage = WPTStorage()
        if let progress = storage.loadPlayerProgress() {
            NSLog("Found player progress for: \(progress.shipName)")
            let player = WPTPlayer(playerProgress: progress)
            let scene = WPTWorldScene(player: player)
            continueLbl = WPTSceneLabelNode(text: "Continue", next: scene)
        } else {
            NSLog("No previous player progress was found")
            continueLbl = nil
        }
        
        // the labels to show
        var labels = [newGame]
        if let continueLbl = continueLbl {
            labels.append(continueLbl)
        }
        labels.append(highScores)
        labels.append(settings)
        
        let spacing = WPTValues.fontSizeSmall + WPTSceneLabelNode.fontSize
        let h = CGFloat(labels.count) * spacing
        let top = self.frame.midY + (h / 2) - WPTValues.fontSizeMedium
        for i in 0..<labels.count {
            let label = labels[i]
            label.position = CGPoint(x: self.frame.midX, y: top - CGFloat(i) * spacing)
            self.addChild(label)
        }
        
        // add background
        background.position(for: self)
        addChild(background)
        
        title.position = CGPoint(x: self.frame.midX / 3.5, y: self.frame.midY * 1.77)
        title.fontColor = UIColor.black
        addChild(title)
        
        treasureChest.position = CGPoint(x: 0.17 * self.frame.width, y: 0.26 * self.frame.height)
        treasureChest.setScale(0.35)
        addChild(treasureChest)
    }
    
    static func getBack(frame: CGRect) -> WPTButtonNode {
        let back = WPTSceneLabelNode(text: "< Back", next: WPTHomeScene())
        back.position = CGPoint(x: 0.15 * frame.width, y: 0.10 * frame.height)
        return back
    }
}
