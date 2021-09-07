//
//  PlayerPlane.swift
//  SpaceWar
//
//  Created by Oleksandr Kurtsev on 19/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import SpriteKit

enum TurnDirection {
    case left
    case right
    case none
}

class PlayerPlane: SKSpriteNode {
    
    var leftTextureArrayAnimation = [SKTexture]()
    var rightTextureArrayAnimation = [SKTexture]()
    var forwardTextureArrayAnimation = [SKTexture]()
    var moveDirection: TurnDirection = .none

    static func populate(at point: CGPoint) -> PlayerPlane {
        let atlas = Assets.shared.playerPlaneAtlas
        let playerPlaneTexture = atlas.textureNamed("airplane_3ver2_13")
        let playerPlane = PlayerPlane(texture: playerPlaneTexture)
        playerPlane.setScale(0.5)
        playerPlane.position = point
        playerPlane.zPosition = 40
        
        // Create Physics Body
        let offsetX = playerPlane.frame.size.width * playerPlane.anchorPoint.x
        let offsetY = playerPlane.frame.size.height * playerPlane.anchorPoint.y
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 71 - offsetX, y: 99 - offsetY))
        path.addLine(to: CGPoint(x: 79 - offsetX, y: 99 - offsetY))
        path.addLine(to: CGPoint(x: 83 - offsetX, y: 89 - offsetY))
        path.addLine(to: CGPoint(x: 140 - offsetX, y: 75 - offsetY))
        path.addLine(to: CGPoint(x: 142 - offsetX, y: 66 - offsetY))
        path.addLine(to: CGPoint(x: 84 - offsetX, y: 57 - offsetY))
        path.addLine(to: CGPoint(x: 65 - offsetX, y: 58 - offsetY))
        path.addLine(to: CGPoint(x: 8 - offsetX, y: 65 - offsetY))
        path.addLine(to: CGPoint(x: 9 - offsetX, y: 76 - offsetY))
        path.addLine(to: CGPoint(x: 67 - offsetX, y: 89 - offsetY))
        path.closeSubpath()
        playerPlane.physicsBody = SKPhysicsBody(polygonFrom: path)
        
        //playerPlane.physicsBody = SKPhysicsBody(texture: playerPlaneTexture, alphaThreshold: 0.5, size: playerPlane.size)
        playerPlane.physicsBody?.isDynamic = false
        playerPlane.physicsBody?.categoryBitMask = BitMaskCategory.player.rawValue
        playerPlane.physicsBody?.collisionBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        playerPlane.physicsBody?.contactTestBitMask = BitMaskCategory.enemy.rawValue | BitMaskCategory.powerUp.rawValue
        
        return playerPlane
    }
    
    func performFly(to point: CGPoint) {
        let point = CGPoint(x: point.x, y: self.position.y)
        let action = SKAction.move(to: point, duration: 0.5)

        self.run(action)
    }
    
    func greenPowerUp() {
        let colorAction = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.2)
        let uncolorAction = SKAction.colorize(with: .green, colorBlendFactor: 0.0, duration: 0.2)
        let sequenceAction = SKAction.sequence([colorAction, uncolorAction])
        let repeatAction = SKAction.repeat(sequenceAction, count: 5)
        self.run(repeatAction)
    }
    
    func bluePowerUp() {
        let colorAction = SKAction.colorize(with: .blue, colorBlendFactor: 1.0, duration: 0.2)
        let uncolorAction = SKAction.colorize(with: .blue, colorBlendFactor: 0.0, duration: 0.2)
        let sequenceAction = SKAction.sequence([colorAction, uncolorAction])
        let repeatAction = SKAction.repeat(sequenceAction, count: 5)
        self.run(repeatAction)
    }
}
