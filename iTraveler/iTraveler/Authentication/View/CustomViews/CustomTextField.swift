//
//  CustomTextField.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 14/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setUpField()
    }
    
    private func setUpField() {
        textAlignment           = .center
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
    }
}
