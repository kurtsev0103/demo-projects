//
//  Assets.swift
//  WarFly
//
//  Created by Oleksandr Kurtsev on 20/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import SpriteKit

class Assets {
    
    static let shared = Assets()
    var isLoaded = false
    
    let playerPlaneAtlas  = SKTextureAtlas(named: "PlayerPlane")
    let enemy_1Atlas      = SKTextureAtlas(named: "Enemy_1")
    let enemy_2Atlas      = SKTextureAtlas(named: "Enemy_2")
    let bluePowerUpAtlas  = SKTextureAtlas(named: "BluePowerUp")
    let greenPowerUpAtlas = SKTextureAtlas(named: "GreenPowerUp")
    let yellowAmmoAtlas   = SKTextureAtlas(named: "YellowAmmo")
    
    func preloadAssets() {
        playerPlaneAtlas.preload { print("playerPlaneAtlas preloaded") }
        enemy_1Atlas.preload { print("enemy_1Atlas preloaded") }
        enemy_2Atlas.preload { print("enemy_2Atlas preloaded") }
        bluePowerUpAtlas.preload { print("bluePowerUpAtlas preloaded") }
        greenPowerUpAtlas.preload { print("greenPowerUpAtlas preloaded") }
        yellowAmmoAtlas.preload { print("yellowAmmoAtlas preloaded") }
    }
}
