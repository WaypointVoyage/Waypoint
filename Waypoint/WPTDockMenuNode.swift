//
//  WPTDockMenuNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/20/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTDockMenuNode: SKNode {
    
    let background: SKSpriteNode
    let dockShroud: SKShapeNode
    let player: WPTLevelPlayerNode
    var itemPicker: WPTItemPickerNode? = nil
    
    var itemNameLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    var doubloonsLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    let moneyImage = SKSpriteNode(imageNamed: "doubloons")
    var priceLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    var descriptionLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeTiny)
    var purchaseLabel = WPTLabelNode(text: "Purchase", fontSize: WPTValues.fontSizeSmall)
    let wahm = WPTLabelNode(text: "Sail >", fontSize: WPTValues.fontSizeSmall)
    
    init(player: WPTLevelPlayerNode) {
        
        self.player = player
        self.background = SKSpriteNode(imageNamed: "pause_scroll")
        self.dockShroud = SKShapeNode(rectOf: WPTValues.screenSize)
        
        super.init()
        self.isUserInteractionEnabled = true
        
        // shroud
        self.dockShroud.fillColor = UIColor.black
        self.dockShroud.strokeColor = UIColor.black
        self.dockShroud.zPosition = WPTValues.pauseShroudZPosition * 2
        self.dockShroud.alpha = 0.6
        self.addChild(self.dockShroud)
        
        // background
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = WPTValues.pauseShroudZPosition * 2
        let width = 0.9 * WPTValues.screenSize.height
        let scale = width / (background.texture?.size().width)!
        background.size = CGSize(width: width, height: 2 * scale * background.texture!.size().height)
        background.zRotation = CGFloat(M_PI) / 2.0
        self.addChild(background)
        
        let titleLabel = WPTLabelNode(text: "Port Stop", fontSize: WPTValues.fontSizeMedium)
        titleLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        titleLabel.fontColor = UIColor.black
        titleLabel.position = CGPoint(x: 2.5, y: 105)
        self.addChild(titleLabel)
        
        var items: [WPTItem] = []
        items.append(WPTItemCatalog.itemsByName["Cannon"]!)
        for _ in 0..<3 {
            items.append(WPTItemCatalog.randomStatModifier())
        }
        
        itemPicker = WPTItemPickerNode(items: items, onChange: updateStats)
        itemPicker!.position = CGPoint(x: -80, y: -20)
        itemPicker!.zPosition = WPTValues.pauseShroudZPosition * 2 + 1
        itemPicker!.setSize(width: background.size.width, height: background.size.height)
        self.addChild(itemPicker!)
        
        itemNameLabel.horizontalAlignmentMode = .center
        itemNameLabel.position = CGPoint(x: -80, y: 55)
        itemNameLabel.fontColor = UIColor.black
        itemNameLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.addChild(itemNameLabel)
        
        doubloonsLabel.horizontalAlignmentMode = .center
        descriptionLabel.position = CGPoint(x: -80, y: -105)
        descriptionLabel.fontColor = UIColor.black
        descriptionLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 3
        self.addChild(descriptionLabel)
        
        let moneyImgSize = 1.8 * WPTValues.fontSizeSmall
        self.moneyImage.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.moneyImage.position = CGPoint(x: 85, y: 60)
        self.moneyImage.size = CGSize(width: moneyImgSize, height: moneyImgSize)
        self.addChild(self.moneyImage)
        
        doubloonsLabel.horizontalAlignmentMode = .left
        doubloonsLabel.position = CGPoint(x: 120, y: 55)
        doubloonsLabel.fontColor = UIColor.black
        doubloonsLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.addChild(doubloonsLabel)
        
        priceLabel.horizontalAlignmentMode = .left
        priceLabel.position = CGPoint(x: 70, y: -5)
        priceLabel.fontColor = UIColor.black
        priceLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.addChild(priceLabel)
        
        purchaseLabel.horizontalAlignmentMode = .left
        purchaseLabel.position = CGPoint(x: 70, y: -42.5)
        purchaseLabel.fontColor = UIColor.black
        purchaseLabel.zPosition = WPTValues.pauseShroudZPosition * 2 + 2
        self.addChild(purchaseLabel)
        
        wahm.horizontalAlignmentMode = .left
        wahm.position = CGPoint(x: 135, y: -130)
        wahm.fontColor = UIColor.black
        wahm.zPosition = WPTValues.pauseShroudZPosition * 2 + 3
        self.addChild(wahm)
        
        updateStats(item: (itemPicker?.currentItem)!)
    }
    
    func updateStats(item: WPTItem) {
        self.itemNameLabel.text = item.name
        self.priceLabel.text = "Price: \(item.value)"
        self.descriptionLabel.text = item.description
    }
    
    func updateDoubloons() {
        self.doubloonsLabel.text = String(player.player.doubloons)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPos = touches.first!.location(in: self)
        
        if !self.background.contains(touchPos) {
            self.removeFromParent()
        } else if self.purchaseLabel.contains(touchPos) {
            purchaseItem()
        } else if self.wahm.contains(touchPos) {
            // update the player's progress
            player.player.health = player.currentHealth
            if let scene = self.scene as? WPTLevelScene {
                player.player.completedLevels.append(scene.level.name)
            }
            
            // save the progress
            player.player.progress = WPTPlayerProgress(player: player.player)
            let storage = WPTStorage()
            storage.savePlayerProgress(player.player.progress!)
            
            // move to the world scene
            self.scene!.view?.presentScene(WPTWorldScene(player: player.player))
        }
    }
    
    private func purchaseItem() {
        
    }
}
