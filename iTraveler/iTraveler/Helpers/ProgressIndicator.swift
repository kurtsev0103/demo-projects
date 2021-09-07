//
//  ProgressIndicator.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 16/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class ProgressIndicator: UIView {
    
    var indicatorColor:     UIColor
    var loadingViewColor:   UIColor
    var textColor:          UIColor
    var loadingMessage:     String
    
    var messageFrame        = UIView()
    var activityIndicator   = UIActivityIndicatorView()
    
    init(view: UIView, loadingViewColor: UIColor, indicatorColor: UIColor, text: String, textColor: UIColor) {
        
        self.indicatorColor     = indicatorColor
        self.loadingViewColor   = loadingViewColor
        self.loadingMessage     = text
        self.textColor          = textColor
        
        super.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        initalizeCustomIndicator(view: view)
    }
    
    convenience init(view: UIView) {
        self.init(view: view, loadingViewColor: .black, indicatorColor: .black, text: "", textColor: .brown)
    }
    
    convenience init(view: UIView, text: String) {
        self.init(view: view, loadingViewColor: .black, indicatorColor: .black, text: text, textColor: .brown)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initalizeCustomIndicator(view: UIView) {
        messageFrame.frame                  = self.bounds
        
        activityIndicator                   = UIActivityIndicatorView(style: .large)
        activityIndicator.tintColor         = indicatorColor
        activityIndicator.hidesWhenStopped  = true
        activityIndicator.center            = self.center

        let textLabel = UILabel(frame: CGRect(x: 0, y: self.frame.height / 2 - 100, width: self.frame.width, height: 50))
        
        textLabel.textAlignment             = .center
        textLabel.font                      = UIFont(name: Fonts.avenir, size: 24)
        textLabel.text                      = loadingMessage
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.textColor                 = textColor
        
        messageFrame.backgroundColor        = loadingViewColor
        messageFrame.alpha                  = 0.8
        
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(textLabel)
    }
    
    func start() {
        if !self.subviews.contains(messageFrame) {
            activityIndicator.startAnimating()
            self.addSubview(messageFrame)
        }
    }
    
    func stop() {
        if self.subviews.contains(messageFrame) {
            activityIndicator.stopAnimating()
            messageFrame.removeFromSuperview()
        }
    }
}
