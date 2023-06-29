//
//  WPTItemPickerNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/20/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation
import SpriteKit

class WPTItemPickerNode: SKNode {
    
    let items: [ItemWrapper]
    var itemTextures = [SKTexture]()
    var index = 0
    
    var onChange: (ItemWrapper) -> Void
    
    let leftArrow = SKSpriteNode(imageNamed: "plank_arrow")
    let rightArrow = SKSpriteNode(imageNamed: "plank_arrow")
    var itemImage = SKSpriteNode(imageNamed: "box")
    
    var width: CGFloat?
    var height: CGFloat?
    
    var currentItem: ItemWrapper {
        get {
            return items[index]
        }
    }
    
    var currentItemTexture: SKTexture {
        get{
            return itemTextures[index]
        }
    }
    
    init(items: [ItemWrapper], onChange: @escaping (ItemWrapper) -> Void) {
        self.items = items
        self.onChange = onChange
        super.init()
        assert(self.items.count >= 1, "At least one item is required!")
        isUserInteractionEnabled = true
        
        // setup the arrows
        if (self.items.count > 1) {
            leftArrow.zRotation = CGFloat.pi
            let arrowSize = 0.08 * WPTValues.screenSize.width
            leftArrow.size = CGSize(width: arrowSize, height: arrowSize)
            rightArrow.size = leftArrow.size
            leftArrow.anchorPoint = CGPoint(x: 1, y: 0.5)
            rightArrow.anchorPoint = CGPoint(x: 1, y: 0.5)
            addChild(leftArrow)
            addChild(rightArrow)
        }
        
        // setup the ship image
        for item in self.items {
            itemTextures.append(SKTexture(imageNamed: item.item.imageName))
        }
        itemImage.texture = currentItemTexture
        itemImage.position = CGPoint.zero
        let itemImgSize = 0.2 * WPTValues.screenSize.width
        itemImage.size = CGSize(width: itemImgSize, height: itemImgSize)
        addChild(itemImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSize(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        
        leftArrow.position = CGPoint(x: -width / 2, y: 0)
        rightArrow.position = CGPoint(x: width / 2, y: 0)
        itemImage.size = CGSize(width: 0.22 * height, height: 0.22 * height)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        var offset = 0
        if leftArrow.contains(touch.location(in: self)) {
            offset = -1
        } else if rightArrow.contains(touch.location(in: self)) {
            offset = 1
        } else {
            return
        }
        
        // update the current ship index, rotating to other end of the array
        index = (index + offset) % items.count
        if index < 0 { // so the % operator in swift is stupid.... -1 % 3 = -1. Not 2
            index += items.count
        }
        itemImage.texture = currentItemTexture
        self.onChange(self.currentItem)
    }
}

class ItemWrapper: NSObject, Codable {
    private let KEY = "some_real_stupid_shit"

    var item: WPTItem
    var itemName: String
    var purchased: Bool = false
    var price: Int

    init(name: String, price: Int, purchased: Bool) {
        self.item = WPTItemCatalog.itemsByName[name]!
        self.itemName = name
        self.purchased = purchased
        self.price = WPTConfig.values.freeItems ? 0 : price
    }

    enum CodingKeys: String, CodingKey {
        case itemName
        case purchased
        case price
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.itemName = try container.decode(String.self, forKey: .itemName)
        self.item = WPTItemCatalog.itemsByName[self.itemName]!
        self.purchased = try container.decode(Bool.self, forKey: .purchased)
        self.price = try container.decode(Int.self, forKey: .price)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(itemName, forKey: .itemName)
        try container.encode(purchased, forKey: .purchased)
        try container.encode(price, forKey: .price)
    }
}
