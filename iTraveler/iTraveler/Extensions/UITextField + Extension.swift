//
//  UITextField + Extension.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 16/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

extension UITextField {
    
    func customizeTF(withIdentView: Bool = false) -> UITextField {
        
        textAlignment           = .left
        tintColor               = .darkGray
        textColor               = .darkGray
        font                    = UIFont(name: Fonts.avenir, size: 18)
        backgroundColor         = UIColor(white: 1.0, alpha: 0.5)
        autocorrectionType      = .no
        layer.cornerRadius      = frame.size.height / 2
        layer.borderWidth       = 2
        layer.borderColor       = UIColor.darkGray.cgColor
        clipsToBounds           = true
        
        let placeholder         = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont     = UIFont(name: Fonts.avenir, size: 18)!
        attributedPlaceholder   = NSAttributedString(string: placeholder, attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
             NSAttributedString.Key.font: placeholderFont])
        
        if withIdentView {
            let indentView        = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            leftView              = indentView
            leftViewMode          = .always
        }
        
        return self
    }
}
