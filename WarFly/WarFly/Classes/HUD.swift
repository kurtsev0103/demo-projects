//
//  HUD.swift
//  WarFly
//
//  Created by Oleksandr Kurtsev on 20/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    
    let scoreBackground = SKSpriteNode(imageNamed: "scores")
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0 {
        didSet {
            scoreLabel.text = score.description
        }
    }
    let menuButton = SKSpriteNode(imageNamed: "menu")
    let life1 = SKSpriteNode(imageNamed: "life")
    let life2 = SKSpriteNode(imageNamed: "life")
    let life3 = SKSpriteNode(imageNamed: "life")

    func configureUI(screenSize: CGSize) {
        scoreBackground.position = CGPoint(x: scoreBackground.size.width + 10, y: screenSize.height - scoreBackground.size.height / 2 - 10)
        scoreBackground.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        scoreBackground.zPosition = 99
        addChild(scoreBackground)
        
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: -10.0, y: 3.0)
        scoreLabel.zPosition = 100
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 30
        scoreBackground.addChild(scoreLabel)
        
        menuButton.position = CGPoint(x: screenSize.width - 10, y: screenSize.height - menuButton.size.height / 2 - 20)
        menuButton.anchorPoint = CGPoint(x: 1, y: 0.5)
        menuButton.zPosition = 100
        menuButton.name = "pause"
        addChild(menuButton)
        
        let lifes = [life1, life2, life3]
        for (index, life) in lifes.enumerated() {
            life.position = CGPoint(x: screenSize.width - CGFloat(index + 1) * (life.size.width + 3), y: 20)
            life.zPosition = 100
            life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            addChild(life)
        }
    }
}
