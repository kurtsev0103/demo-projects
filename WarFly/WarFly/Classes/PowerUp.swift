//
//  PowerUp.swift
//  SpaceWar
//
//  Created by Oleksandr Kurtsev on 19/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import SpriteKit

class PowerUp: SKSpriteNode {
    
    private let initalSize = CGSize(width: 52, height: 52)
    private let textureAtlas: SKTextureAtlas!
    private var textureNameBeginsWith = ""
    private var animationSpriteArray = [SKTexture]()
    
    init(textureAtlas: SKTextureAtlas) {
        self.textureAtlas = textureAtlas
        
        let textureName = textureAtlas.textureNames.sorted()[0]
        let texture = textureAtlas.textureNamed(textureName)
        textureNameBeginsWith = String(textureName.dropLast(6))
        
        super.init(texture: texture, color: .clear, size: initalSize)
        self.setScale(0.7)
        self.name = "sprite"
        self.zPosition = 20
        
        // Create Physics Body
        let offsetX = self.frame.size.width * self.anchorPoint.x
        let offsetY = self.frame.size.height * self.anchorPoint.y
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 12 - offsetX, y: 99 - offsetY))
        path.addLine(to: CGPoint(x: 22 - offsetX, y: 99 - offsetY))
        path.addLine(to: CGPoint(x: 22 - offsetX, y: 30 - offsetY))
        path.addLine(to: CGPoint(x: 12 - offsetX, y: 30 - offsetY))
        path.closeSubpath()
        self.physicsBody = SKPhysicsBody(polygonFrom: path)
        
        //self.physicsBody = SKPhysicsBody(texture: texture, alphaThreshold: 0.5, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = BitMaskCategory.powerUp.rawValue
        self.physicsBody?.collisionBitMask = BitMaskCategory.player.rawValue
        self.physicsBody?.contactTestBitMask = BitMaskCategory.player.rawValue
    }
    
    func startMovement() {
        performRotation()
        
        let moveForward = SKAction.moveTo(y: -100, duration: 5)
        self.run(moveForward)
    }
    
    private func performRotation() {
        for i in 1...15 {
            let number = String(format: "%02d", i)
            animationSpriteArray.append(SKTexture(imageNamed: textureNameBeginsWith + number))
        }
        
        SKTexture.preload(animationSpriteArray) {
            let rotation = SKAction.animate(with: self.animationSpriteArray, timePerFrame: 0.05, resize: true, restore: false)
            let rotationForever = SKAction.repeatForever(rotation)
            self.run(rotationForever)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
