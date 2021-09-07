//
//  AuthViewController.swift
//  iTraveler
//
//  Created by Oleksandr Kurtsev on 14/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var loginButton: CustomButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        prepareTextFields()
        prepareButtons()     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
        emailTF.text = ""
        passwordTF.text = ""
    }

    // MARK: - Private Method
    
    private func prepareButtons() {
        loginButton.setTitle(kButtonLoginTitle, for: .normal)
        
        restoreButton.setTitle(kButtonRestoreTitle, for: .normal)
        restoreButton.setTitleColor(.darkGray, for: .normal)
        restoreButton.titleLabel?.font = UIFont(name: Fonts.avenir, size: 20)
        
        registrationButton.setTitle(kButtonRegistrationTitle, for: .normal)
        registrationButton.setTitleColor(.darkGray, for: .normal)
        registrationButton.titleLabel?.font = UIFont(name: Fonts.avenir, size: 20)
    }
    
    private func prepareTextFields() {
        emailTF.placeholder = kLoginTFPlaceholder
        emailTF.returnKeyType = .next
        emailTF.keyboardType = .emailAddress
        emailTF.delegate = self
        
        passwordTF.placeholder = kPassTFPlaceholder
        passwordTF.returnKeyType = .done
        passwordTF.keyboardType = .default
        passwordTF.isSecureTextEntry = true
        passwordTF.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Keyboard Notifications
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(AuthViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AuthViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loginAction(_ sender: CustomButton) {
        sender.shake()
        
        AuthManager.shared.login(email: emailTF.text!, password: passwordTF.text!) { (result) in
            switch result {
            case .success(_):
                self.showAlert(title: kAlertSuccess, message: kYouAreAuthorized) {
                    self.goToMainViewController()
                }
            case .failure(let error):
                self.showAlert(title: kAlertError, message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF: passwordTF.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}
