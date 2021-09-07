//
//  Enemy.swift
//  SpaceWar
//
//  Created by Oleksandr Kurtsev on 19/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import SpriteKit

enum EnemyDirection: Int {
    case left = 0
    case right
}

class Enemy: SKSpriteNode {
    
    static var textureAtlas: SKTextureAtlas?
    var enemyTexture: SKTexture?
    
    init(enemyTexture: SKTexture) {
        let texture = enemyTexture
        super.init(texture: texture, color: .clear, size: CGSize(width: 221, height: 224))
        self.xScale = 0.5
        self.yScale = -0.5
        self.zPosition = 20
        self.name = "sprite"
        
        // Create Physics Body
        let offsetX = self.frame.size.width * self.anchorPoint.x
        let offsetY = self.frame.size.height * self.anchorPoint.y
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 52 - offsetX, y: 96 - offsetY))
        path.addLine(to: CGPoint(x: 59 - offsetX, y: 96 - offsetY))
        path.addLine(to: CGPoint(x: 63 - offsetX, y: 84 - offsetY))
        path.addLine(to: CGPoint(x: 104 - offsetX, y: 70 - offsetY))
        path.addLine(to: CGPoint(x: 103 - offsetX, y: 63 - offsetY))
        path.addLine(to: CGPoint(x: 66 - offsetX, y: 50 - offsetY))
        path.addLine(to: CGPoint(x: 47 - offsetX, y: 51 - offsetY))
        path.addLine(to: CGPoint(x: 8 - offsetX, y: 61 - offsetY))
        path.addLine(to: CGPoint(x: 8 - offsetX, y: 71 - offsetY))
        path.addLine(to: CGPoint(x: 48 - offsetX, y: 84 - offsetY))
        path.closeSubpath()
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        
        //self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.none.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue | BitMaskCategory.shot.rawValue
    }
    
    func flySpiral() {
        let screenSize = UIScreen.main.bounds
        let timeHorizontal = 3.0
        let timeVertical = 5.0
        
        let moveLeft = SKAction.moveTo(x: 50, duration: timeHorizontal)
        let moveRight = SKAction.moveTo(x: screenSize.width - 50, duration: timeHorizontal)
        
        moveLeft.timingMode = .easeInEaseOut
        moveRight.timingMode = .easeInEaseOut
        
        let randomNumber = Int(arc4random_uniform(2))
        let asideMovementSequence = randomNumber == EnemyDirection.left.rawValue ? SKAction.sequence([moveLeft, moveRight]) : SKAction.sequence([moveRight, moveLeft])
        let foreverAsideMovement = SKAction.repeatForever(asideMovementSequence)
        
        let forwardMovement = SKAction.moveTo(y: -105, duration: timeVertical)
        let groupMovement = SKAction.group([foreverAsideMovement, forwardMovement])
        self.run(groupMovement)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
