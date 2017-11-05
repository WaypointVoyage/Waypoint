//
//  WPTPauseMenuNode.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/15/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTPauseMenuNode: SKNode {
    
    private let exit = WPTLabelNode(text: "Quit", fontSize: WPTValues.fontSizeSmall)
    private let reset = WPTLabelNode(text: "Reset Level", fontSize: WPTValues.fontSizeSmall)
    var map: WPTMapViewNode
    private var background: SKSpriteNode! = nil
    private var levelNameNode: WPTLabelNode? = nil
    let pauseEffect = WPTAudioNode(effect: "map_scroll")
    var levelName: String? = nil {
        didSet { self.levelNameNode?.text = self.levelName }
    }
    
    // stuff for confirming a quit
    private var confirmingQuit: Bool = false
    private let warning: [WPTLabelNode] = [
        WPTLabelNode(text: "Quitting now will", fontSize: WPTValues.fontSizeSmall),
        WPTLabelNode(text: "erase all progress!", fontSize: WPTValues.fontSizeSmall),
        WPTLabelNode(text: "Are you sure you", fontSize: WPTValues.fontSizeSmall),
        WPTLabelNode(text: "want to quit?", fontSize: WPTValues.fontSizeSmall),
    ]
    private let confirmQuit = WPTLabelNode(text: "Yes", fontSize: WPTValues.fontSizeSmall)
    private let cancelQuit = WPTLabelNode(text: "Cancel", fontSize: WPTValues.fontSizeSmall)
    
    init(terrain: WPTTerrainNode) {
        self.map = WPTMapViewNode(terrain: terrain)
        
        super.init()
        self.isUserInteractionEnabled = true
        
        // background
        background = SKSpriteNode(imageNamed: "pause_scroll")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = WPTZPositions.shrouds + 1
        let width = 0.9 * WPTValues.screenSize.height
        let scale = width / (background.texture?.size().width)!
        background.size = CGSize(width: width, height: scale * background.texture!.size().height)
        background.zRotation = CG_PI / 2.0
        self.addChild(background)
        
        // level name
        self.levelNameNode = WPTLabelNode(text: "", fontSize: WPTValues.fontSizeSmall)
        levelNameNode!.zPosition = background.zPosition + 1
        levelNameNode!.fontColor = UIColor.black
        levelNameNode!.position.y += 0.5 * background.size.height
        self.addChild(levelNameNode!)
        
        //map
        self.map.zPosition = background.zPosition + 1
        scaleMap()
        self.addChild(map)
        
        // reset
        reset.zPosition = background.zPosition + 1
        reset.fontColor = UIColor.black
        reset.position.y -= 0.4 * background.size.height
        if WPTConfig.values.testing { self.addChild(self.reset) }
        
        // exit
        exit.zPosition = background.zPosition + 1
        exit.fontColor = UIColor.black
        exit.position.y -= 0.5 * background.size.height
        self.addChild(exit)
        
        /* Confirm Quit stuff */
        
        for i in 0..<self.warning.count {
            let warn = self.warning[i]
            warn.fontColor = .black
            warn.position.y += background.size.height * 0.25 - CGFloat(i) * WPTValues.fontSizeSmall
            warn.zPosition = background.zPosition + 1
        }
        
        self.confirmQuit.zPosition = background.zPosition + 1
        self.confirmQuit.fontColor = .black
        self.confirmQuit.position.y -= 0.5 * background.size.height
        self.confirmQuit.position.x -= 0.15 * background.size.width
        
        self.cancelQuit.zPosition = background.zPosition + 1
        self.cancelQuit.fontColor = .black
        self.cancelQuit.position.y -= 0.5 * background.size.height
        self.cancelQuit.position.x += 0.15 * background.size.width
        
        self.addChild(pauseEffect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scaleMap() {
        let width: CGFloat = 0.7 * background.frame.width
        let height: CGFloat = 0.5 * background.frame.height
        let targetAspect = width / height
        let actualAspect = self.map.width / self.map.height
        

        if actualAspect > targetAspect {
            self.map.setScale(width / self.map.width)
        } else {
            self.map.setScale(height / self.map.height)
        }
        self.map.position.y += 0.05 * background.frame.height
    }
    
    private func startConfirmQuit() {
        guard !self.confirmingQuit else { return }
        
        // remove current UI stuff
        self.levelNameNode?.removeFromParent()
        self.map.removeFromParent()
        self.exit.removeFromParent()
        self.reset.removeFromParent()
        
        // add confirm UI stuff
        self.addChild(self.confirmQuit)
        self.addChild(self.cancelQuit)
        for warn in self.warning {
            self.addChild(warn)
        }
        
        self.confirmingQuit = true
    }
    
    func cancelConfirmQuit() {
        guard self.confirmingQuit else { return }
        
        // remove confirm UI stuff
        self.confirmQuit.removeFromParent()
        self.cancelQuit.removeFromParent()
        for warn in self.warning {
            warn.removeFromParent()
        }
        
        // put back normal UI stuff
        self.addChild(self.levelNameNode!)
        self.addChild(self.map)
        self.addChild(self.exit)
        if WPTConfig.values.testing { self.addChild(self.reset) }
        
        self.confirmingQuit = false
    }
    
    private func actuallyQuit() {
        // erase save data
        let storage = WPTStorage()
        storage.clearPlayerProgress()
        self.scene?.view?.presentScene(WPTHomeScene())
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPos = touches.first!.location(in: self)
        
        if (self.confirmingQuit) {
            if self.confirmQuit.contains(touchPos) {
                self.actuallyQuit()
            } else if self.cancelQuit.contains(touchPos) {
                self.cancelConfirmQuit()
            }
        }
        
        else {
            if self.exit.contains(touchPos) {
                startConfirmQuit()
            } else if self.reset.contains(touchPos) {
                if let scene = self.scene as? WPTLevelScene {
                    scene.view?.presentScene(WPTLevelScene(player: scene.player.player, level: scene.level))
                }
            }
        }
    }
}
