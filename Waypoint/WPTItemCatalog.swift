//
//  WPTItemCatalog.swift
//  Waypoint
//
//  Created by Cameron Taylor on 3/3/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTItemCatalog {
    
    static let itemsByName: [String:WPTItem] = {
        var items = [String:WPTItem]()
        for itemGroup in [("currency_items", WPTItemTier.currency),
                         ("repair_items", WPTItemTier.repair),
                         ("stat_modifier_items", WPTItemTier.statModifier),
                         ("other_items", WPTItemTier.other)] {
            
            let theFile = Bundle.main.path(forResource: itemGroup.0, ofType: "plist")
            for itemDict in NSArray(contentsOfFile: theFile!) as! [[String:AnyObject]] {
                
                var item: WPTItem! = nil
                switch itemGroup.1 {
                case WPTItemTier.currency:
                    item = WPTItem(asCurrency: itemDict)
                case WPTItemTier.repair:
                    item = WPTItem(asRepair: itemDict)
                case WPTItemTier.statModifier:
                    item = WPTItem(asStatModifier: itemDict)
                case WPTItemTier.other:
                    item = WPTItem(itemDict)
                }
                
                assert(items[item.name] != nil, "An item with the name \(item.name) already exists!")
                items[item.name] = item
            }
            
        }
        return items
    }()
    
    static let allItems = WPTItemCatalog.itemsByName.values
    static let currencyItems: [WPTItem] = allItems.filter { $0.tier == WPTItemTier.currency }
    static let repairItems: [WPTItem] = allItems.filter { $0.tier == WPTItemTier.repair }
    static let statModifierItems: [WPTItem] = allItems.filter { $0.tier == WPTItemTier.statModifier }
    
    private static let currencyPrevalenceMap = PrevalenceMap(for: WPTItemCatalog.currencyItems)
    private static let repairPrevalenceMap = PrevalenceMap(for: WPTItemCatalog.repairItems)
    private static let statModifierPrevalenceMap = PrevalenceMap(for: WPTItemCatalog.statModifierItems)
    
    private class PrevalenceMap {
        private var map = [WPTItem]()
        private let min: Int = 0
        private let max: Int
        
        init(for items: [WPTItem]) {
            for item in items {
                map.append(item)
            }
            max = map.count
            assert(max >= 1)
        }
        
        func random() -> WPTItem {
            let rand = CGFloat(arc4random()) / CGFloat(UInt32.max)
            let index = CGFloat(max - min) * rand + CGFloat(min)
            return self.map[Int(index)]
        }
    }
    
    static let randomCurrency = WPTItemCatalog.currencyPrevalenceMap.random
    static let randomRepair = WPTItemCatalog.repairPrevalenceMap.random
    static let randomStatModifier = WPTItemCatalog.statModifierPrevalenceMap.random
}
