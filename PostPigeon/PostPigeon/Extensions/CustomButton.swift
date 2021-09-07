//
//  CustomButton.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 23/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

enum CustomButtonType {
    case withBorder
    case text
    case plain
}

class CustomButton: UIButton {
    
    private var buttonColor: UIColor!
    private var isHaveBorder = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String, buttonColor: UIColor, type: CustomButtonType) {
        self.init(type: .system)
        
        self.buttonColor = buttonColor
        setTitle(title, for: .normal)
        setTitleColor(buttonColor, for: .normal)
        setTitleColor(.black, for: .highlighted)

        titleLabel?.font                = Fonts.avenir20
        titleLabel?.shadowColor         = Colors.niceDark
        titleLabel?.shadowOffset        = CGSize(width: 4, height: 4)
        
        switch type {
        case .withBorder:
            layer.cornerRadius = 25
            layer.borderWidth = 3
            layer.borderColor = buttonColor.cgColor
            clipsToBounds = true
            isHaveBorder = true
        case .plain:
            backgroundColor = buttonColor
            setTitleColor(Colors.niceWhite, for: .normal)
            layer.cornerRadius = 25
            clipsToBounds = true
        case .text:
            break
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            guard isHaveBorder else { return }
            backgroundColor = isHighlighted ? buttonColor : .clear
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
