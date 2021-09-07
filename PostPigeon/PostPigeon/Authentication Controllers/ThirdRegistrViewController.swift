//
//  ThirdRegistrViewController.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 23/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit
import Firebase

class ThirdRegistrViewController: UIViewController {

    private let emailTF = CustomTextField(type: .login)
    private let passwordTF = CustomTextField(type: .password)
    private let passwordTwoTF = CustomTextField(type: .password)
    private var progressIndicator: ProgressIndicator?
    private let backButton = CustomButton(title: kButtonBack, buttonColor: Colors.niceRed, type: .withBorder)
    private let registrationButton = CustomButton(title: kButtonRegistration, buttonColor: Colors.niceWhite, type: .withBorder)
    
    var userModel: MUser!
    var userImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackground()
        setupConstraints()
        setupTextFileds()
        setupButtons()
        prepareProgressIndicator()
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
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [backButton, registrationButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        passwordTwoTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTwoTF)
        
        NSLayoutConstraint.activate([
            passwordTwoTF.heightAnchor.constraint(equalToConstant: 50),
            passwordTwoTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            passwordTwoTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            passwordTwoTF.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20)
        ])
        
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTF)
        
        NSLayoutConstraint.activate([
            passwordTF.heightAnchor.constraint(equalToConstant: 50),
            passwordTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            passwordTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            passwordTF.bottomAnchor.constraint(equalTo: passwordTwoTF.topAnchor, constant: -5)
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
        passwordTwoTF.delegate = self
        passwordTwoTF.placeholder = kPlaceholderConfirmPass
        passwordTwoTF.returnKeyType = .done
    }
    
    private func setupButtons() {
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        registrationButton.addTarget(self, action: #selector(registrationAction), for: .touchUpInside)
    }
    
    private func prepareProgressIndicator() {
        progressIndicator = ProgressIndicator(view: view, loadingViewColor: UIColor(white: 1, alpha: 0.4), indicatorColor: .black, text: kAlertMessPleaseWait, textColor: .black)
        progressIndicator?.isHidden = true
        self.view.addSubview(progressIndicator!)
    }
    
    private func animationRegistration() {
        view.endEditing(true)
        backButton.isHidden = true
        registrationButton.isHidden = true
        emailTF.isHidden = true
        passwordTF.isHidden = true
        passwordTwoTF.isHidden = true
        progressIndicator?.isHidden = false
        progressIndicator!.start()
    }
    
    private func saveAllUserData() {
        FirestoreManager.shared.saveProfile(muser: userModel, userImage: userImage) { (result) in
            switch result {
            case .success(let muser):
                self.progressIndicator!.stop()
                self.showAlert(title: kAlertTitleSuccess, message: kAlertMessYouAreRegistered) {
                    let mainTB = MainTabBarController(currentUser: muser)
                    mainTB.modalPresentationStyle = .fullScreen
                    self.present(mainTB, animated: true)
                }
            case .failure(let error):
                self.showAlert(title: kAlertTitleError, message: error.localizedDescription)
            }
        }
    }
    
    private func saveUserImage(currentUser: User) {
        userModel.id = currentUser.uid
        userModel.email = currentUser.email!
        
        StorageManager.shared.upload(userPhoto: userImage, userId: userModel.id) { (result) in
            switch result {
            case .success(let url):
                self.userModel.avatarStringURL = url.absoluteString
                self.saveAllUserData()
            case .failure(let error):
                self.showAlert(title: kAlertTitleError, message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func registrationAction() {
        AuthManager.shared.register(email: emailTF.text, password: passwordTF.text, confirmPassword: passwordTwoTF.text) { (result) in
            switch result {
            case .success(let user):
                self.animationRegistration()
                self.saveUserImage(currentUser: user)
            case .failure(let error):
                self.showAlert(title: kAlertTitleError, message: error.localizedDescription)
            }
        }
    }
    
    @objc func backAction() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension ThirdRegistrViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTF: passwordTF.becomeFirstResponder()
        case passwordTF: passwordTwoTF.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Keyboard Notifications

extension ThirdRegistrViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ThirdRegistrViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ThirdRegistrViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
