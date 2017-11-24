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
    let level: WPTLevel
    var itemPicker: WPTItemPickerNode? = nil
    var itemInventory: [ItemWrapper]! = nil
    
    var itemNameLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    var doubloonsLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    let moneyImage = SKSpriteNode(imageNamed: "doubloons")
    var priceLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
    var descriptionLabel = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeTiny)
    var purchaseLabel = WPTButtonNode(text: "Purchase", fontSize: WPTValues.fontSizeSmall)
    let wahm = WPTButtonNode(text: "Sail >", fontSize: WPTValues.fontSizeSmall)
    
    private let priceScale: Float
    
    init(player: WPTLevelPlayerNode, level: WPTLevel) {
        
        self.player = player
        self.background = SKSpriteNode(imageNamed: "pause_scroll")
        self.dockShroud = SKShapeNode(rectOf: WPTValues.screenSize)
        self.level = level
        
        self.priceScale = max(Float(player.player.difficulty), Float(level.difficulty))
        
        super.init()
        self.isUserInteractionEnabled = true
        
        // shroud
        self.dockShroud.fillColor = UIColor.black
        self.dockShroud.strokeColor = UIColor.black
        self.doubloonsLabel.zPosition = WPTZPositions.shrouds + 10
        self.dockShroud.alpha = 0.6
        self.addChild(self.dockShroud)
        
        // background
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = dockShroud.zPosition + 1
        let width = 0.9 * WPTValues.screenSize.height
        let scale = width / (background.texture?.size().width)!
        background.size = CGSize(width: width, height: 2 * scale * background.texture!.size().height)
        background.zRotation = CG_PI / 2.0
        self.addChild(background)
        
        let titleLabel = WPTLabelNode(text: "Port Shop", fontSize: WPTValues.fontSizeMedium)
        titleLabel.zPosition = background.zPosition + 1
        titleLabel.fontColor = UIColor.black
        titleLabel.position = CGPoint(x: 0, y: 0.30 * dockShroud.frame.height)
        self.addChild(titleLabel)
        
        itemNameLabel.horizontalAlignmentMode = .center
        itemNameLabel.position = CGPoint(x: -0.12 * dockShroud.frame.size.width, y: 0.15 * dockShroud.frame.height)
        itemNameLabel.fontColor = UIColor.black
        itemNameLabel.zPosition = background.zPosition + 1
        self.addChild(itemNameLabel)
        
        if (player.player.completedLevels.contains(level.name) && player.player.progress?.levelDockInventory[level.name] != nil) {
            self.itemInventory = (player.player.progress!.levelDockInventory[level.name])!
        } else {
            self.itemInventory = getRandomItems(numItems: 3)
        }
        
        itemPicker = WPTItemPickerNode(items: self.itemInventory, onChange: updateStats)
        itemPicker!.position = CGPoint(x: -0.12 * dockShroud.frame.size.width, y: -0.05 * dockShroud.frame.height)
        itemPicker!.zPosition = background.zPosition + 1
        itemPicker!.setSize(width: 0.7 * background.size.width, height: background.size.height)
        self.addChild(itemPicker!)
        
        descriptionLabel.horizontalAlignmentMode = .center
        descriptionLabel.position = CGPoint(x: -0.12 * dockShroud.frame.size.width, y: -0.29 * dockShroud.frame.height)
        descriptionLabel.fontColor = UIColor.black
        descriptionLabel.zPosition = background.zPosition + 1
        self.addChild(descriptionLabel)
        
        let moneyImgSize = 1.8 * WPTValues.fontSizeSmall
        self.moneyImage.zPosition = background.zPosition + 1
        self.moneyImage.position = CGPoint(x: 0.13 * dockShroud.frame.width, y: 0.17 * dockShroud.frame.height)
        self.moneyImage.size = CGSize(width: moneyImgSize, height: moneyImgSize)
        self.addChild(self.moneyImage)
        
        doubloonsLabel.horizontalAlignmentMode = .left
        doubloonsLabel.position = CGPoint(x: 0.17 * dockShroud.frame.width, y: 0.14 * dockShroud.frame.height)
        doubloonsLabel.fontColor = UIColor.black
        doubloonsLabel.zPosition = background.zPosition + 1
        self.addChild(doubloonsLabel)
        
        priceLabel.horizontalAlignmentMode = .left
        priceLabel.position = CGPoint(x: 0.10 * dockShroud.frame.width, y: 0)
        priceLabel.fontColor = UIColor.black
        priceLabel.zPosition = background.zPosition + 1
        self.addChild(priceLabel)
        
        purchaseLabel.position = CGPoint(x: 0.185 * dockShroud.frame.width, y: -0.12 * dockShroud.frame.height)
        purchaseLabel.zPosition = background.zPosition + 1
        self.addChild(purchaseLabel)
        
        wahm.position = CGPoint(x: 0.22 * dockShroud.frame.size.width, y: -0.31 * dockShroud.frame.size.height)
        wahm.zPosition = background.zPosition + 1
        self.addChild(wahm)
        
        updateStats(item: (itemPicker?.currentItem)!)
    }
    
    func updateStats(item: ItemWrapper) {
        self.itemNameLabel.text = item.item.name
        self.descriptionLabel.text = item.item.description
        if (player.doubloons < item.price || item.purchased) {
            self.purchaseLabel.disabled = true
        } else {
            self.purchaseLabel.disabled = false
        }
        if (item.purchased) {
            self.priceLabel.text = "Price: Bought"
            self.itemPicker!.itemImage.alpha = 0.5
        } else {
            self.priceLabel.text = "Price: \(item.price)"
            self.itemPicker!.itemImage.alpha = 1.0
        }
    }
    
    func updateDoubloons() {
        self.doubloonsLabel.text = String(player.doubloons)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPos = touches.first!.location(in: self)
        
        if !self.background.contains(touchPos) {
            self.removeFromParent()
        } else if self.purchaseLabel.contains(touchPos) && !self.purchaseLabel.disabled {
            purchaseItem()
        } else if self.wahm.contains(touchPos) {
            // update the player's progress
            if let scene = self.scene as? WPTLevelScene {
                player.player.completedLevels.append(scene.level.name)
            }
            
            // save the progress
            player.player.progress = WPTPlayerProgress(playerNode: player)
            player.player.progress?.print()
            let storage = WPTStorage()
            player.player.progress!.levelDockInventory[level.name] = self.itemInventory
            storage.savePlayerProgress(player.player.progress!)

            // move to the world scene
            NSLog("HEALTH: Leaving level with \(player.health) out of \(player.player.ship.health)")
            self.scene!.view?.presentScene(WPTWorldScene(player: player.player))
        }
    }
    
    private func getRandomItems(numItems: Int) -> [ItemWrapper] {
        var items: [ItemWrapper] = []
        
        for name in ["Ship Maintenance Minor", "Ship Maintenance Major", "Ship Maintenance Complete"] {
            let shipMaintenance = WPTItemCatalog.itemsByName[name]!
            let maintenanceWrapper = ItemWrapper(name: shipMaintenance.name, price: Int(priceScale * Float(shipMaintenance.value)), purchased: false)
            NSLog("Adding '\(name)' of price \(maintenanceWrapper.price) to dock inventory")
            items.append(maintenanceWrapper)
        }
        
        if !self.player.hasAllCannons {
            let cannon = WPTItemCatalog.itemsByName["Cannon"]!
            let cannonWrapper = ItemWrapper(name: cannon.name, price: Int(priceScale * Float(cannon.value)), purchased: false)
            NSLog("Adding cannon of price \(cannonWrapper.price) to dock inventory")
            items.append(cannonWrapper)
        }
        
        for _ in 0..<numItems {
            var found = false
            while (!found) {
                let randItem = WPTItemCatalog.randomStatModifier()
                let duplicate = items.contains(where: { (item) -> Bool in
                    item.itemName == randItem.name
                })
                if (!duplicate) {
                    let itemWrapper = ItemWrapper(name: randItem.name, price: Int(priceScale * Float(randItem.value)), purchased: false)
                    NSLog("Adding \(itemWrapper.item.name) of price \(itemWrapper.price) to dock inventory")
                    items.append(itemWrapper)
                    found = true
                }
            }
        }
        
        return items
    }
    
    private func purchaseItem() {
        NSLog("PURCHASE: buying \(itemPicker!.currentItem.itemName) for \(itemPicker!.currentItem.price)")
        player.doubloons -= itemPicker!.currentItem.price
        assert(player.doubloons >= 0)
        updateDoubloons()
        if let hud = (self.scene as? WPTLevelScene)?.hud {
            hud.top.updateMoney()
        }
        self.itemPicker!.itemImage.alpha = 0.5
        self.priceLabel.text = "Price: Bought"
        self.purchaseLabel.disabled = true
        itemPicker!.currentItem.purchased = true
        player.give(item: itemPicker!.currentItem.item)
        updateDock(item: itemPicker!.currentItem)
    }
    
    private func updateDock(item: ItemWrapper) {
        for i in self.itemInventory {
            if i.itemName == item.itemName {
                i.purchased = item.purchased
                break
            }
        }
    }
}
