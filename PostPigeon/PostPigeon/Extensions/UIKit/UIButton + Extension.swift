//
//  UIButton + Extension.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 25/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(title: String, titleColor: UIColor, backColor: UIColor, withShadow: Bool = false) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = backgroundColor
        titleLabel?.font = Fonts.avenir20
        
        layer.cornerRadius = 10
        
        if withShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowRadius = 4
            layer.shadowOpacity = 0.2
            layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
}
