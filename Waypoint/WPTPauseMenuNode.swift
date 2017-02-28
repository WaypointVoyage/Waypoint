//
//  WPTPauseMenuNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/15/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPauseMenuNode: SKNode {
    
    private let exit = WPTLabelNode(text: "Exit", fontSize: WPTValues.fontSizeSmall)
    private let reset = WPTLabelNode(text: "Reset Level", fontSize: WPTValues.fontSizeSmall)
    private var map: WPTMapView
    private var levelNameNode: WPTLabelNode? = nil
    var levelName: String? = nil {
        didSet { self.levelNameNode?.text = self.levelName }
    }
    
    init(terrain: WPTTerrainNode) {
        self.map = WPTMapView(terrain: terrain)
        
        super.init()
        self.isUserInteractionEnabled = true
        
        
        // background
        let background = SKSpriteNode(imageNamed: "pause_scroll")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = WPTValues.pauseShroudZPosition + 1
        let width = 0.9 * WPTValues.screenSize.height
        let scale = width / (background.texture?.size().width)!
        background.size = CGSize(width: width, height: scale * background.texture!.size().height)
        background.zRotation = CGFloat(M_PI) / 2.0
        self.addChild(background)
        
        // level name
        self.levelNameNode = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
        levelNameNode!.zPosition = WPTValues.pauseShroudZPosition + 2
        levelNameNode!.fontColor = UIColor.black
        levelNameNode!.position.y += 0.5 * background.size.height
        self.addChild(levelNameNode!)
        
        //map
        self.map.zPosition = WPTValues.pauseShroudZPosition + 2
        self.map.position = CGPoint(x: 0-85, y: 0-85)
        scaleMap()
        self.addChild(map)
        
        // reset
        reset.zPosition = WPTValues.pauseShroudZPosition + 2
        reset.fontColor = UIColor.black
        reset.position.y -= 0.4 * background.size.height
        if WPTConfig.values.testing { self.addChild(self.reset) }
        
        // exit
        exit.zPosition = WPTValues.pauseShroudZPosition + 2
        exit.fontColor = UIColor.black
        exit.position.y -= 0.5 * background.size.height
        self.addChild(exit)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scaleMap() {
        var bound = SKShapeNode(rectOf: self.map.calculateAccumulatedFrame().size)
        let width = 0.9 * WPTValues.screenSize.height
        var scale = 1.0
        print("Pause Width: \(width)")
        print("Map Width: \(bound.frame.width)")
        while (bound.frame.width  > width/2 || bound.frame.height > width/2) {
            scale -= 0.01
            self.map.setScale(CGFloat(scale))
            bound = SKShapeNode(rectOf: self.map.calculateAccumulatedFrame().size)
            bound.fillColor = UIColor.magenta
            print("Width: \(bound.frame.width)")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPos = touches.first!.location(in: self)
        
        if self.exit.contains(touchPos) {
            self.scene?.view?.presentScene(WPTHomeScene())
        } else if self.reset.contains(touchPos) {
            if let scene = self.scene as? WPTLevelScene {
                scene.view?.presentScene(WPTLevelScene(player: scene.player.player, level: scene.level))
            }
        }
    }
}
