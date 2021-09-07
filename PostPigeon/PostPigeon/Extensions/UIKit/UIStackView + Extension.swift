//
//  UIStackView + Extension.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 25/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

extension UIStackView {
    
    convenience init(subviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: subviews)
        self.axis = axis
        self.spacing = spacing
    }
}
