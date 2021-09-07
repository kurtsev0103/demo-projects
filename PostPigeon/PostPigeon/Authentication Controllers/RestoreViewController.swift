//
//  RestoreViewController.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 23/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class RestoreViewController: UIViewController {
    
    private let emailTF = CustomTextField(type: .login)
    private let cancelButton = CustomButton(title: kButtonCancel, buttonColor: Colors.niceRed, type: .withBorder)
    private let sendButton = CustomButton(title: kButtonSend, buttonColor: Colors.niceWhite, type: .withBorder)
    
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
        emailTF.text = ""
        removeObservers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, sendButton])
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
        
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTF)
        
        NSLayoutConstraint.activate([
            emailTF.heightAnchor.constraint(equalToConstant: 50),
            emailTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            emailTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            emailTF.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20)
        ])
    }
    
    private func setupTextFileds() {
        emailTF.delegate = self
        emailTF.returnKeyType = .done
    }
    
    private func setupButtons() {
        cancelButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func sendAction() {
        AuthManager.shared.resetPassword(email: emailTF.text) { (result) in
            switch result {
            case .success(_):
                self.view.endEditing(true)
                self.showAlert(title: kAlertTitleSuccess, message: kAlertMessRecovery) {
                    self.dismiss(animated: true)
                }
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

extension RestoreViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Keyboard Notifications

extension RestoreViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(RestoreViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RestoreViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
