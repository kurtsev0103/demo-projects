//
//  BitMaskCategory.swift
//  WarFly
//
//  Created by Oleksandr Kurtsev on 20/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import SpriteKit

extension SKPhysicsBody {
    var category: BitMaskCategory {
        get {
            return BitMaskCategory(rawValue: self.categoryBitMask)
        }
        
        set {
            self.categoryBitMask = newValue.rawValue
        }
    }
}

struct BitMaskCategory: OptionSet {
    let rawValue: UInt32
    
    static let none     = BitMaskCategory(rawValue: 0 << 0)         // 00000...00000    (0)
    static let player   = BitMaskCategory(rawValue: 1 << 0)         // 00000...00001    (1)
    static let enemy    = BitMaskCategory(rawValue: 1 << 1)         // 00000...00010    (2)
    static let powerUp  = BitMaskCategory(rawValue: 1 << 2)         // 00000...00100    (4)
    static let shot     = BitMaskCategory(rawValue: 1 << 3)         // 00000...01000    (8)
    static let all      = BitMaskCategory(rawValue: UInt32.max)     // 11111...11111
    
    //static let player:  UInt32 = 0x1 << 0   // 00000...00001    (1)
    //static let enemy:   UInt32 = 0x1 << 1   // 00000...00010    (2)
    //static let powerUp: UInt32 = 0x1 << 2   // 00000...00100    (4)
    //static let shot:    UInt32 = 0x1 << 3   // 00000...01000    (8)
}
