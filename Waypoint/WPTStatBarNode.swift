//
//  WPTStatBarNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/10/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTStatBarNode: SKNode {
    static let fontSize = WPTValues.fontSizeSmall
    static let texture = SKTexture(imageNamed: "stat_bar")
    let shader = SKShader(fileNamed: "stat_bar.fsh")
    
    let label = WPTLabelNode(text: "", fontSize: WPTStatBarNode.fontSize)
    let statBar = SKSpriteNode(texture: WPTStatBarNode.texture)
    
    var statMin: CGFloat
    var statMax: CGFloat
    var statVal: CGFloat
    var statUniform: SKUniform
    
    init(_ labelText: String) {
        self.statMin = 0
        self.statMax = 1
        self.statVal = 0.2
        self.statUniform = SKUniform(name: "stat_val", float: 0.2)
        super.init()
        
        self.label.text = labelText
        self.label.horizontalAlignmentMode = .right
        self.label.verticalAlignmentMode = .center
        self.addChild(self.label)
        self.shader.addUniform(self.statUniform)
        self.statBar.shader = self.shader
        self.addChild(self.statBar)
    }
    
    func setWidth(_ width: CGFloat) {
        let spacing: CGFloat = 8
        let barWidth = width - 0.35 * width - 2 * spacing
        self.statBar.scale(to: CGSize(width: barWidth, height: self.label.fontSize))
        self.statBar.position.x = spacing + self.statBar.frame.width / 2
    }
    
    func setStat(_ value: CGFloat, min: CGFloat? = nil, max: CGFloat? = nil) {
        self.statVal = value
        self.statMax = max == nil ? self.statMax : max!
        self.statMin = min == nil ? self.statMin : min!
        self.statBar.shader!.uniformNamed("stat_val")!.floatValue = Float(self.statVal / (self.statMax - self.statMin))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
