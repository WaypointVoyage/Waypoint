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
    private let levelLabel = WPTLabelNode(text: "Level", fontSize: WPTValues.fontSizeSmall)
    private let doubloonLabel = WPTLabelNode(text: "Doubloons", fontSize: WPTValues.fontSizeSmall)
    private let continueLabel = WPTLabelNode(text: "Continue >", fontSize: WPTValues.fontSizeSmall)
    private var levelNameNode: WPTLabelNode? = nil
    private var doubloons: WPTLabelNode
    private var level: WPTLabelNode
    private var player: WPTPlayer
    
    init(player: WPTPlayer) {
        
        self.player = player
        self.doubloons = WPTLabelNode(text: String(player.doubloons), fontSize: WPTValues.fontSizeSmall)
        
        //may need to change later once player progress is implemented
        self.level = WPTLabelNode(text: String(player.completedLevels.count + 1), fontSize: WPTValues.fontSizeSmall)
        
        super.init()
        self.isUserInteractionEnabled = true
        
        
        // background
        let background = SKSpriteNode(imageNamed: "pause_scroll")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = WPTValues.pauseShroudZPosition + 1
        let width = 0.9 * WPTValues.screenSize.height
        let scale = width / (background.texture?.size().width)!
        background.size = CGSize(width: width, height: 2 * scale * background.texture!.size().height)
        background.zRotation = CGFloat(M_PI) / 2.0
        self.addChild(background)
        
        //ship image
        let shipImage = SKSpriteNode(imageNamed: player.ship.previewImage)
        shipImage.position.x -= background.size.width * 0.3
        let shipImgSize = 0.25 * WPTValues.screenSize.width
        shipImage.size = CGSize(width: shipImgSize, height: shipImgSize)
        shipImage.zPosition = WPTValues.pauseShroudZPosition + 2
        self.addChild(shipImage)
        
        // game over
        gameOver.zPosition = WPTValues.pauseShroudZPosition + 2
        gameOver.fontColor = UIColor.black
        gameOver.position.y += 0.2 * background.size.height
        self.addChild(gameOver)
        
        // levelLabel
        levelLabel.zPosition = WPTValues.pauseShroudZPosition + 2
        levelLabel.fontColor = UIColor.black
        levelLabel.position.y += 0.05 * background.size.height
        levelLabel.position.x += 0.1 * background.size.height
        self.addChild(levelLabel)
        
        // level
        level.zPosition = WPTValues.pauseShroudZPosition + 2
        level.fontColor = UIColor.black
        level.position.y += 0.35 * background.size.height
        level.position.x += 0.1 * background.size.height
        self.addChild(level)
        
        // doubloonLabel
        doubloonLabel.zPosition = WPTValues.pauseShroudZPosition + 2
        doubloonLabel.fontColor = UIColor.black
        doubloonLabel.position.y -= 0.04 * background.size.height
        doubloonLabel.position.x += 0.15 * background.size.height
        self.addChild(doubloonLabel)
        
        doubloons.zPosition = WPTValues.pauseShroudZPosition + 2
        doubloons.fontColor = UIColor.black
        doubloons.position.y -= 0.04 * background.size.height
        doubloons.position.x += 0.32 * background.size.height
        self.addChild(doubloons)
        
        continueLabel.zPosition = WPTValues.pauseShroudZPosition + 2
        continueLabel.fontColor = UIColor.black
        continueLabel.position.y -= 0.25 * background.size.height
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
            
            self.scene?.view?.presentScene(WPTHighScoresScene())
        }
    }
}
