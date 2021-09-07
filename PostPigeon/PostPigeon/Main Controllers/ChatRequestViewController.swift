//
//  ChatRequestViewController.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 25/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: UIImage(named: "human1"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Oleksandr Kurtsev", font: Fonts.avenir26)
    let aboutMeLabel = UILabel(text: kTitleNewChat, font: Fonts.avenir16)
    let acceptButton = UIButton(title: kButtonAccept, titleColor: .white, backColor: .black)
    let denyButton = UIButton(title: kButtonDeny, titleColor: Colors.niceRed, backColor: Colors.mainWhite)
    
    private var chat: MChat
    
    init(chat: MChat) {
        self.chat = chat
        nameLabel.text = chat.friendUsername
        imageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeElements()
        setupConstraints()
        
        view.backgroundColor = Colors.mainWhite
        
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    @objc private func denyButtonTapped() {
        dismiss(animated: true) {
            FirestoreManager.shared.deleteWaitingChat(chat: self.chat) { (result) in
                switch result {
                case .success():
                    //TODO
                    self.showAlert(title: kAlertTitleSuccess, message: "")
                case .failure(let error):
                    //TODO
                    self.showAlert(title: kAlertTitleError, message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func acceptButtonTapped() {
        dismiss(animated: true) {
            FirestoreManager.shared.changeToActive(chat: self.chat) { (result) in
                switch result {
                case .success():
                    //TODO
                    self.showAlert(title: kAlertTitleSuccess, message: "")
                case .failure(let error):
                    //TODO
                    self.showAlert(title: kAlertTitleError, message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false

        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = Colors.niceRed.cgColor
        
        containerView.backgroundColor = Colors.mainWhite
        containerView.layer.cornerRadius = 30
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        acceptButton.applyGradients(cornerRadius: 10)
    }
}

// MARK: - Setup Constraints
extension ChatRequestViewController {
    private func setupConstraints() {
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        
        let buttonsStackView = UIStackView(subviews: [denyButton, acceptButton], axis: .horizontal, spacing: 10)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .fillEqually
        containerView.addSubview(buttonsStackView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])

        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

