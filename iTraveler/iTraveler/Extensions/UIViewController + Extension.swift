//
//  UIViewController + Extension.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 15/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Background
    
    func setBackground() {
        let backgroundImageView = UIImageView()
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: kNameBackgroundImage)
        view.sendSubviewToBack(backgroundImageView)
    }

    // MARK: - Alerts
    func showAlert(title: String, message: String, completion: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: kAlertOk, style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func showLogoutActionSheet(completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: kActionSheetLogout, style: .destructive) { (_) in
            completion()
        }
        let cancelAction = UIAlertAction(title: kActionSheetCancel, style: .cancel)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Navigations
    func goToMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nvc = storyboard.instantiateViewController(withIdentifier: "MainNavigationViewController")
        nvc.modalPresentationStyle = .fullScreen
        nvc.modalTransitionStyle = .crossDissolve
        self.present(nvc, animated: true)
    }
    
    func goToAuthViewController() {
        let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        })
    }
}
