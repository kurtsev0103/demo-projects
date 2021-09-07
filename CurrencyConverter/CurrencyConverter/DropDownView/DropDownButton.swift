//
//  DropDownButton.swift
//  CurrencyConverter
//
//  Created by Oleksandr Kurtsev on 08/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class DropDownButton: UIButton {
    
    var dropDownView = DropDownView()
    var height = NSLayoutConstraint()
    var isOpen = false
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDropDownView()
    }
    
    private func setupDropDownView() {
        dropDownView = DropDownView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.dropDownOptions = kAvailableCurrencies.sorted()
        dropDownView.delegate = self
    }
    
    private func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropDownView.center.y -= self.dropDownView.frame.height / 2
            self.dropDownView.layoutIfNeeded()
        })
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropDownView)
        self.superview?.bringSubviewToFront(dropDownView)
        NSLayoutConstraint.activate([
            dropDownView.topAnchor.constraint(equalTo: self.bottomAnchor),
            dropDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dropDownView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
        height = dropDownView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen {
            dismissDropDown()
        } else {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            let heightSuperview = superview?.bounds.height //667
            let heightSelf = self.frame.height //50
            let indent = self.frame.minY //40 || 96
            self.height.constant = heightSuperview! - heightSelf - indent
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropDownView.layoutIfNeeded()
                self.dropDownView.center.y += self.dropDownView.frame.height / 2
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDropDownView()
    }
}

// MARK: - DropDownProtocol
extension DropDownButton: DropDownProtocol {
    func dropDownPressed(string: String) {
        setTitle(string, for: .normal)
        dismissDropDown()
    }
}
