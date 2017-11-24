//
//  WPTDestroyMenuNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTDestroyMenuNode: SKNode {
    
    //Thar She Blows
    private let gameOver = WPTLabelNode(text: "Game Over Matey!", fontSize: WPTValues.fontSizeMedium)
    private let shipName = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    private let doubloonImage = SKSpriteNode(imageNamed: "doubloons")
    private let continueLabel = WPTButtonNode(text: "Continue >", fontSize: WPTValues.fontSizeSmall)
    private var doubloons: WPTLabelNode
    private var levelsCompleted: WPTLabelNode
    private var player: WPTLevelPlayerNode
    
    init(player: WPTLevelPlayerNode) {
        
        self.player = player
        self.levelsCompleted = WPTLabelNode(text: "Level: \(self.player.player.completedLevels.count + 1)", fontSize: WPTValues.fontSizeSmall)
        self.doubloons = WPTLabelNode(text: String(player.doubloons), fontSize: WPTValues.fontSizeSmall)
        super.init()
        self.isUserInteractionEnabled = true
        self.zPosition = WPTZPositions.shrouds + 1
        
        // background
        let background = SKSpriteNode(imageNamed: "pause_scroll")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let width = 0.9 * WPTValues.screenSize.height
        let scale = width / (background.texture?.size().width)!
        background.size = CGSize(width: width, height: 2 * scale * background.texture!.size().height)
        background.zRotation = CG_PI / 2.0
        self.addChild(background)
        
        //ship image
        let shipImage = SKSpriteNode(imageNamed: player.player.ship.previewImage)
        shipImage.position.x -= background.size.width * 0.3
        shipImage.position.y -= 0.05 * background.size.height
        let shipImgSize = 0.25 * WPTValues.screenSize.width
        shipImage.size = CGSize(width: shipImgSize, height: shipImgSize)
        shipImage.zPosition = 1
        self.addChild(shipImage)
        
        // game over
        gameOver.zPosition = 1
        gameOver.fontColor = UIColor.black
        gameOver.position.y += 0.2 * background.size.height
        self.addChild(gameOver)
        
        // levelLabel
        shipName.horizontalAlignmentMode = .center
        shipName.zPosition = 1
        shipName.fontColor = UIColor.black
        shipName.text = player.player.shipName
        shipName.position.y += 0.14 * background.size.height
        self.addChild(shipName)
        
        //levelsBeatenLabel
        levelsCompleted.zPosition = 1
        levelsCompleted.fontColor = UIColor.black
        levelsCompleted.position.y += 0.03 * background.size.height
        levelsCompleted.position.x += 0.12 * background.size.height
        self.addChild(levelsCompleted)
        
        // doubloonLabel
        doubloonImage.zPosition = 1
        let doubloonImgSize = 1.8 * WPTValues.fontSizeSmall
        doubloonImage.size = CGSize(width: doubloonImgSize, height: doubloonImgSize)
        doubloonImage.position.y -= 0.05 * background.size.height
        doubloonImage.position.x += 0.09 * background.size.height
        self.addChild(doubloonImage)
        
        doubloons.zPosition = 1
        doubloons.fontColor = UIColor.black
        doubloons.position.y -= 0.06 * background.size.height
        doubloons.position.x += 0.18 * background.size.height
        self.addChild(doubloons)
        
        continueLabel.zPosition = 1
        continueLabel.position.y -= 0.22 * background.size.height
        continueLabel.position.x += 0.25 * background.size.height
        self.addChild(continueLabel)
        
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMoney() {
        self.doubloons.text = String(player.doubloons)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if self.continueLabel.contains(touch.location(in: self)) {
            let lootSummary = WPTLootSummary(player: self.player)
            let storage = WPTStorage()
            storage.submitScore(lootSummary)
            let highScores = WPTHighScoresScene()
            highScores.song = "level_map_theme.wav"
            self.scene?.view?.presentScene(highScores)
        }
    }
}
