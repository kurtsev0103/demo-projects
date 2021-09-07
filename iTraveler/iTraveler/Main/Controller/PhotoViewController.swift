//
//  PhotoViewController.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 27/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import Alamofire

class PhotoViewController: UIViewController {
        
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var image: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        customizeElements()
        getTextForImage()
    }
    
    private func customizeElements() {
        navigationItem.hidesBackButton = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        textLabel.text = ""
        textLabel.font = UIFont(name: Fonts.avenir, size: 16)
        textLabel.minimumScaleFactor = 0.1
        textLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    private func getTextForImage() {
        
        NetworkManager.shared.convertImageToText(image: image) { (result) in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                guard let text = NetworkHelpers.shared.parseText(data) else { return }
                
                NetworkManager.shared.getTranslatedText(text: text) { (result) in
                    switch result {
                        
                    case .success(let data):
                        guard let data = data else { return }
                        guard let text = NetworkHelpers.shared.parseTranslatedText(data) else { return }
                        
                        DispatchQueue.main.async {
                            self.navigationItem.hidesBackButton = false
                            self.activityIndicator.startAnimating()
                            self.activityIndicator.isHidden = true
                            self.textLabel.text = text
                        }
                        
                    case .failure(let error):
                        self.showAlert(title: kAlertError, message: error.localizedDescription)
                    }
                }

            case .failure(let error):
                self.showAlert(title: kAlertError, message: error.localizedDescription)
            }
        }
    }
}
