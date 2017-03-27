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
    private let doubloonLabel = WPTLabelNode(text: "Doubloons", fontSize: WPTValues.fontSizeSmall)
    private let continueLabel = WPTButtonNode(text: "Continue >", fontSize: WPTValues.fontSizeSmall)
    private var doubloons: WPTLabelNode
    private var player: WPTPlayer
    
    init(player: WPTPlayer) {
        
        self.player = player
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
        background.zRotation = CGFloat(M_PI) / 2.0
        self.addChild(background)
        
        //ship image
        let shipImage = SKSpriteNode(imageNamed: player.ship.previewImage)
        shipImage.position.x -= background.size.width * 0.3
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
        shipName.horizontalAlignmentMode = .left
        shipName.zPosition = 1
        shipName.fontColor = UIColor.black
        shipName.text = player.shipName
        shipName.position.y += 0.05 * background.size.height
        shipName.position.x -= 0.01 * background.size.height
        self.addChild(shipName)
        
        // doubloonLabel
        doubloonLabel.zPosition = 1
        doubloonLabel.fontColor = UIColor.black
        doubloonLabel.position.y -= 0.04 * background.size.height
        doubloonLabel.position.x += 0.1 * background.size.height
        self.addChild(doubloonLabel)
        
        doubloons.zPosition = 1
        doubloons.fontColor = UIColor.black
        doubloons.position.y -= 0.04 * background.size.height
        doubloons.position.x += 0.27 * background.size.height
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
            
            self.scene?.view?.presentScene(WPTHighScoresScene())
        }
    }
}
