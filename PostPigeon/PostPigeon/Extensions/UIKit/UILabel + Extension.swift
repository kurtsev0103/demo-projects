//
//  UILabel + Extension.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 24/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont?) {
        self.init()
        self.text = text
        self.font = font
    }
}
