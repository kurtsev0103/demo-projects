//
//  LoginViewController.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 22/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private let emailTF = CustomTextField(type: .login)
    private let passwordTF = CustomTextField(type: .password)
    private let loginButton = CustomButton(title: kButtonLogin, buttonColor: Colors.niceWhite, type: .withBorder)    
    private let restoreButton = CustomButton(title: kButtonRestore, buttonColor: Colors.niceWhite, type: .text)
    private let registrationButton = CustomButton(title: kButtonRegistration, buttonColor: Colors.niceWhite, type: .text)

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackground()
        setupConstraints()
        setupTextFileds()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods    
    private func customizeElements() {

    }
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [registrationButton, restoreButton])
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20)
        ])
        
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTF)
        
        NSLayoutConstraint.activate([
            passwordTF.heightAnchor.constraint(equalToConstant: 50),
            passwordTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            passwordTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            passwordTF.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20)
        ])
        
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTF)
        
        NSLayoutConstraint.activate([
            emailTF.heightAnchor.constraint(equalToConstant: 50),
            emailTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            emailTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            emailTF.bottomAnchor.constraint(equalTo: passwordTF.topAnchor, constant: -5)
        ])
    }
    
    private func setupTextFileds() {
        emailTF.delegate = self
        passwordTF.delegate = self
        passwordTF.returnKeyType = .done
    }
    
    private func setupButtons() {
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restoreAction), for: .touchUpInside)
        registrationButton.addTarget(self, action: #selector(registrationAction), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func loginAction() {
        AuthManager.shared.login(email: emailTF.text, password: passwordTF.text) { (result) in
            switch result {
            case .success(let user):
                self.showAlert(title: kAlertTitleSuccess, message: kAlertMessYouAreAuthorized) {
                    FirestoreManager.shared.getUserData(user: user) { (result) in
                        switch result {
                        case .success(let muser):
                            let mainTB = MainTabBarController(currentUser: muser)
                            mainTB.modalPresentationStyle = .fullScreen
                            self.present(mainTB, animated: true)
                        case .failure(let error):
                            self.showAlert(title: kAlertTitleError, message: error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(title: kAlertTitleError, message: error.localizedDescription)
            }
        }
    }
    
    @objc func restoreAction() {
        let vc = RestoreViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func registrationAction() {
        let vc = FirstRegistrViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF: passwordTF.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Keyboard Notifications

extension LoginViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
}
