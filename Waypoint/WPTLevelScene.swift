//
//  WPTLevelScene.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/6/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTLevelScene: WPTScene {
    
    private static let levelNameTag = "LEVEL_NAME_TAG"
    
    let level: WPTLevel
    
    let player: WPTLevelPlayerNode
    let hud: WPTHudNode
    
    var levelPaused: Bool = false {
        didSet { self.pauseChanged() }
    }
    
    init(player: WPTPlayer, level: WPTLevel) {
        self.player = WPTLevelPlayerNode(player: player)
        self.level = level
        self.hud = WPTHudNode(player: self.player.player)
        super.init(size: CGSize(width: 0, height: 0))
        
        self.scene?.backgroundColor = UIColor.cyan
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.removeAllChildren()
        
        self.player.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(self.player)
        
        self.addChild(self.hud)
        
        self.loadLevel()
        
        // breif flash of level name
        let levelName = WPTLabelNode(text: self.level.name, fontSize: WPTValues.fontSizeLarge)
        levelName.name = WPTLevelScene.levelNameTag
        levelName.position = CGPoint(x: self.frame.midX, y: 0.7 * self.frame.height)
        levelName.alpha = 0
        levelName.fontColor = UIColor.black
        self.addChild(levelName)
        WPTLabelNode.fadeInOut(levelName, 0.5, 2, 2, 2, completion: {
            levelName.removeFromParent()
        })
    }
    
    private func loadLevel() {
        print("loading level: \(self.level.name)")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if self.levelPaused { return } // everything below this is subject to the pause
        
        self.hud.update(currentTime)
    }
        
    private func pauseChanged() {
        if let levelName = self.childNode(withName: WPTLevelScene.levelNameTag) {
            levelName.isPaused = self.levelPaused
        }
    }
}
