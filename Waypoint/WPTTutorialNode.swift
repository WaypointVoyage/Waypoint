//
//  WPTTutorialNode.swift
//  Waypoint
//
//  Created by Hilary Schulz on 3/19/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import SpriteKit

class WPTTutorialNode: SKNode {
    
    let onComplete: () -> Void
    let pauseShroud: SKShapeNode
    var tutorialImages: [TutorialWrapper] = []
    var tutorialIndex = 0
    var hud: WPTHudNode

    
    init(hud: WPTHudNode, onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        self.hud = hud
        self.pauseShroud = SKShapeNode(rectOf: WPTValues.screenSize)
        
        super.init()
        self.isUserInteractionEnabled = true
        self.zPosition = WPTZPositions.shrouds
        hud.isUserInteractionEnabled = false
        
        // shroud
        self.pauseShroud.fillColor = UIColor.black
        self.pauseShroud.strokeColor = UIColor.black
        self.pauseShroud.zPosition = WPTZPositions.shrouds
        self.pauseShroud.alpha = 0.6
        self.addChild(self.pauseShroud)
        
        let image1 = SKSpriteNode(imageNamed: "tutorial_1")
        tutorialImages.append(TutorialWrapper(image: image1))
        
        let image2 = SKSpriteNode(imageNamed: "tutorial_2")
        tutorialImages.append(TutorialWrapper(image: image2))
        
        let image3 = SKSpriteNode(imageNamed: "tutorial_3")
        tutorialImages.append(TutorialWrapper(image: image3, viewElement: hud.bottom.wheel))
        
        let image4 = SKSpriteNode(imageNamed: "tutorial_4")
        tutorialImages.append(TutorialWrapper(image: image4, viewElement: hud.bottom.anchor))
        
        let image5 = SKSpriteNode(imageNamed: "tutorial_5")
        tutorialImages.append(TutorialWrapper(image: image5, viewElement: hud.bottom.fire))
        
        let image6 = SKSpriteNode(imageNamed: "tutorial_6")
        tutorialImages.append(TutorialWrapper(image: image6, viewElement: hud.top.pause))
        
        let image7 = SKSpriteNode(imageNamed: "tutorial_7")
        tutorialImages.append(TutorialWrapper(image: image7))
        
        let image8 = SKSpriteNode(imageNamed: "tutorial_8")
        tutorialImages.append(TutorialWrapper(image: image8))
        
        for item in tutorialImages {
            item.image.zPosition = pauseShroud.zPosition + 1
            item.image.anchorPoint = CGPoint(x: 0.5, y: 0.55)
        }
        
        addTutorialImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (tutorialIndex < 7) {
            removeTutorialImage()
            addTutorialImage()
        } else {
            removeTutorialImage()
            pauseShroud.removeFromParent()
            hud.isUserInteractionEnabled = true
            onComplete()
        }
    }
    
    private func removeTutorialImage() {
        if (tutorialIndex <= 7) {
            let oldImage = tutorialImages[tutorialIndex]
            oldImage.image.removeFromParent()
            tutorialIndex += 1
            if (oldImage.viewElement != nil) {
                oldImage.viewElement?.zPosition = oldImage.zValue!
            }
        }
    }
    
    private func addTutorialImage() {
        let currentImage = tutorialImages[tutorialIndex]
        self.addChild(currentImage.image)
        if (currentImage.viewElement != nil) {
            currentImage.viewElement!.zPosition = pauseShroud.zPosition * 2
        }
    }
}

class TutorialWrapper {
    
    var image: SKSpriteNode
    var viewElement: SKNode?
    var zValue: CGFloat?
    
    init(image: SKSpriteNode, viewElement: SKNode? = nil) {
        self.image = image
        self.viewElement = viewElement
        if (self.viewElement != nil) {
            self.zValue = self.viewElement?.zPosition
        }
    }
}
