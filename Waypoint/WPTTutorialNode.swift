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
    var tutorialImages: [SKSpriteNode] = []
    var tutorialIndex = 0

    
    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        self.pauseShroud = SKShapeNode(rectOf: WPTValues.screenSize)
        
        super.init()
        self.isUserInteractionEnabled = true
        
        // shroud
        self.pauseShroud.fillColor = UIColor.black
        self.pauseShroud.strokeColor = UIColor.black
        self.pauseShroud.zPosition = WPTValues.pauseShroudZPosition * 2
        self.pauseShroud.alpha = 0.6
        self.addChild(self.pauseShroud)
        
        let image1 = SKSpriteNode(imageNamed: "tutorial_1")
        let image2 = SKSpriteNode(imageNamed: "tutorial_2")
        let image3 = SKSpriteNode(imageNamed: "tutorial_3")
        let image4 = SKSpriteNode(imageNamed: "tutorial_4")
        let image5 = SKSpriteNode(imageNamed: "tutorial_5")
        tutorialImages.append(image1)
        tutorialImages.append(image2)
        tutorialImages.append(image3)
        tutorialImages.append(image4)
        tutorialImages.append(image5)
        
        for image in tutorialImages {
            image.zPosition = WPTValues.pauseShroudZPosition * 2
            image.anchorPoint = CGPoint(x: 0.5, y: 0.55)
        }
        
        self.addChild(tutorialImages[tutorialIndex])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (tutorialIndex < 4) {
            tutorialImages[tutorialIndex].removeFromParent()
            tutorialIndex += 1
            self.addChild(tutorialImages[tutorialIndex])
        } else {
            tutorialImages[tutorialIndex].removeFromParent()
            pauseShroud.removeFromParent()
            onComplete()
        }
    }
}
