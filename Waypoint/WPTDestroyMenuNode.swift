//
//  WPTDestroyMenuNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/9/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTDestroyMenuNode: SKNode {
    
    private let gameOver = WPTLabelNode(text: "Game Over Matey!", fontSize: WPTValues.fontSizeMedium)
    private let level = WPTLabelNode(text: "Level", fontSize: WPTValues.fontSizeSmall)
    private let doubloons = WPTLabelNode(text: "Doubloons", fontSize: WPTValues.fontSizeSmall)
    private var levelNameNode: WPTLabelNode? = nil
    var levelName: String? = nil {
        didSet { self.levelNameNode?.text = self.levelName }
    }
    
    init(player: WPTPlayer) {
        
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
        
        
        // level name
        self.levelNameNode = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
        levelNameNode!.zPosition = WPTValues.pauseShroudZPosition + 2
        levelNameNode!.fontColor = UIColor.black
        levelNameNode!.position.y += 0.5 * background.size.height
        self.addChild(levelNameNode!)
        
        // game over
        gameOver.zPosition = WPTValues.pauseShroudZPosition + 2
        gameOver.fontColor = UIColor.black
        gameOver.position.y += 0.2 * background.size.height
        self.addChild(gameOver)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPos = touches.first!.location(in: self)
        
//        if self.exit.contains(touchPos) {
//            self.scene?.view?.presentScene(WPTHomeScene())
//        } else if self.reset.contains(touchPos) {
//            if let scene = self.scene as? WPTLevelScene {
//                scene.view?.presentScene(WPTLevelScene(player: scene.player.player, level: scene.level))
//            }
//        }
    }
}
