//
//  PasswordTextField.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 22/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

enum TextFieldType {
    case login
    case password
    case address
}

class CustomTextField: UITextField {
    
    private var isHaveView = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    convenience init(type: TextFieldType) {
        self.init()
        
        switch type {
        case .login:
            placeholder         = kPlaceholderEmail
            textAlignment       = .left
            
            leftView            = UIImageView(image: UIImage(named: kImageNameEmail))
            leftView?.frame     = CGRect(x: 0, y: 0, width: 20, height: 20)
            leftViewMode        = .always
            isHaveView          = true
            
        case .password:
            placeholder         = kPlaceholderPassword
            textAlignment       = .left
            isSecureTextEntry   = true
            
            leftView            = UIImageView(image: UIImage(named: kImageNamePassword))
            leftViewMode        = .always
            
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: kImageNameShowPass), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
            rightView           = button
            rightViewMode       = .always
            isHaveView          = true
            
        case .address:
            placeholder         = kPlaceholderAddress
            textAlignment       = .left
            returnKeyType       = .done
            isHaveView          = true
        }
    }
    
    private func setupTextField() {
        backgroundColor         = UIColor(white: 1.0, alpha: 0.5)
        textColor               = Colors.niceDark
        tintColor               = Colors.niceDark
        font                    = Fonts.avenir20
        textAlignment           = .center
        autocapitalizationType  = .none
        autocorrectionType      = .no
        layer.cornerRadius      = 25
        returnKeyType           = .next
        clipsToBounds           = true
    }
    
    @objc private func showPassword(sender: UIButton) {
        if isSecureTextEntry {
            sender.setImage(UIImage(named: kImageNameHidePass), for: .normal)
        } else {
            sender.setImage(UIImage(named: kImageNameShowPass), for: .normal)
        }
        isSecureTextEntry = !isSecureTextEntry
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 10, y: 10, width: 30, height: 30)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: frame.width - 40, y: frame.height - 40, width: 30, height: 30)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if isHaveView {
            return bounds.insetBy(dx: 50, dy: 0)
        } else {
            return bounds.insetBy(dx: 20, dy: 0)
        }
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isHaveView {
            return bounds.insetBy(dx: 50, dy: 0)
        } else {
            return bounds.insetBy(dx: 20, dy: 0)
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if isHaveView {
            return bounds.insetBy(dx: 50, dy: 0)
        } else {
            return bounds.insetBy(dx: 20, dy: 0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
