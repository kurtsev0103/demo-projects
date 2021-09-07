//
//  OptionsScene.swift
//  WarFly
//
//  Created by Oleksandr Kurtsev on 20/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import SpriteKit

class OptionsScene: ParentScene {
    
    var isMusic: Bool!
    var isSound: Bool!

    override func didMove(to view: SKView) {
        isMusic = gameSettings.isMusic
        isSound = gameSettings.isSound

        setHeader(withName: "options", andBackground: "header_background")
        
        let backgroundNameForMusic = isMusic == true ? "music" : "nomusic"
        let music = ButtonNode(title: nil, backgroundName: backgroundNameForMusic)
        music.position = CGPoint(x: self.frame.midX - 50, y: self.frame.midY)
        music.name = "music"
        music.label.isHidden = true
        addChild(music)
        
        let backgroundNameForSound = isSound == true ? "sound" : "nosound"
        let sound = ButtonNode(title: nil, backgroundName: backgroundNameForSound)
        sound.position = CGPoint(x: self.frame.midX + 50, y: self.frame.midY)
        sound.name = "sound"
        sound.label.isHidden = true
        addChild(sound)
        
        let back = ButtonNode(title: "back", backgroundName: "button_background")
        back.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        back.name = "back"
        back.label.name = "back"
        addChild(back)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "music" {
            
            isMusic = !isMusic
            update(node: node as! SKSpriteNode, property: isMusic)
            
        } else if node.name == "sound" {
            
            isSound = !isSound
            update(node: node as! SKSpriteNode, property: isSound)

        } else if node.name == "back" {
            
            gameSettings.isMusic = isMusic
            gameSettings.isSound = isSound
            gameSettings.saveGameSettings()
            
            let transition = SKTransition.crossFade(withDuration: 1.0)
            guard let backScene = backScene else { return }
            backScene.scaleMode = .aspectFill
            self.scene!.view?.presentScene(backScene, transition: transition)
        }
    }
    
    func update(node: SKSpriteNode, property: Bool) {
        if let name = node.name {
            node.texture = property ? SKTexture(imageNamed: name) : SKTexture(imageNamed: "no" + name)
        }
    }
}
