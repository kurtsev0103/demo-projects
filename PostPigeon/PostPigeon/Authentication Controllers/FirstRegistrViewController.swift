//
//  FirstRegistrViewController.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 23/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class FirstRegistrViewController: UIViewController {
    
    private let segmentedControl = UISegmentedControl()
    private let imageView = UIImageView(image: UIImage(named: kImageNameAvatar))
    private let cancelButton = CustomButton(title: kButtonCancel, buttonColor: Colors.niceRed, type: .withBorder)
    private let nextButton = CustomButton(title: kButtonNext, buttonColor: Colors.niceWhite, type: .withBorder)
    private let firstNameTF = CustomTextField()
    private let lastNameTF = CustomTextField()
    private let bornDateTF = CustomTextField()
    private let datePicker = UIDatePicker()
    private let secondVC = SecondRegistrViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackground()
        setupConstraints()
        setupTextFileds()
        setupImageView()
        setupButtons()
        setupSegmentedControl()
        setupDatePicker()
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
        let stackView = UIStackView(arrangedSubviews: [cancelButton, nextButton])
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
        
        bornDateTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bornDateTF)
        
        NSLayoutConstraint.activate([
            bornDateTF.heightAnchor.constraint(equalToConstant: 50),
            bornDateTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            bornDateTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            bornDateTF.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20)
        ])
        
        lastNameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lastNameTF)
        
        NSLayoutConstraint.activate([
            lastNameTF.heightAnchor.constraint(equalToConstant: 50),
            lastNameTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            lastNameTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            lastNameTF.bottomAnchor.constraint(equalTo: bornDateTF.topAnchor, constant: -5)
        ])
        
        firstNameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstNameTF)
        
        NSLayoutConstraint.activate([
            firstNameTF.heightAnchor.constraint(equalToConstant: 50),
            firstNameTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            firstNameTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            firstNameTF.bottomAnchor.constraint(equalTo: lastNameTF.topAnchor, constant: -5)
        ])
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            segmentedControl.bottomAnchor.constraint(equalTo: firstNameTF.topAnchor, constant: -20)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -50)
        ])
    }
    
    private func setupTextFileds() {
        firstNameTF.placeholder = kPlaceholderFirstName
        firstNameTF.autocapitalizationType = .words
        firstNameTF.delegate = self
        
        lastNameTF.placeholder = kPlaceholderLastName
        lastNameTF.autocapitalizationType = .words
        lastNameTF.delegate = self
        
        bornDateTF.placeholder = kPlaceholderBornDate
        bornDateTF.delegate = self
    }
    
    private func setupDatePicker() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))

        let toolbar = UIToolbar()
        toolbar.backgroundColor = Colors.niceBlue
        toolbar.setItems([doneButton], animated: true)
        toolbar.sizeToFit()
        
        bornDateTF.inputAccessoryView = toolbar
        bornDateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = -18
        let maxDate = calendar.date(byAdding: components, to: Date())
        components.year = -60
        let minDate = calendar.date(byAdding: components, to: Date())
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
    }
    
    private func setupButtons() {
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    private func setupSegmentedControl() {
        segmentedControl.insertSegment(withTitle: kSegmentedMan, at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: kSegmentedWoman, at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: kSegmentedOther, at: 2, animated: true)
        segmentedControl.selectedSegmentTintColor = Colors.niceWhite
        segmentedControl.selectedSegmentIndex = 0
        let font: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: Colors.niceDark, NSAttributedString.Key.font: Fonts.avenir16!]
        segmentedControl.setTitleTextAttributes(font, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc func nextAction() {
        guard Validators.isFilledTextFields(firstNameTF.text, lastNameTF.text, bornDateTF.text) && Validators.isMissingSpaces(firstNameTF.text) &&
            Validators.isMissingSpaces(lastNameTF.text) else {
                showAlert(title: kAlertTitleError, message: kAlertTitleNotFilled)
                return
        }
        
        guard imageView.image != UIImage(named: kImageNameAvatar) else {
            showAlert(title: kAlertTitleError, message: kAlertTitlePhotoNotExist)
            return
        }
        
        var muser = MUser()
        muser.firstName = (firstNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        muser.lastName = (lastNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        muser.bornDate = bornDateTF.text!
        muser.gender = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .flipHorizontal
        secondVC.userModel = muser
        secondVC.userImage = imageView.image
        self.present(secondVC, animated: true)
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "dd.MM.yyyy"
        bornDateTF.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension FirstRegistrViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTF: lastNameTF.becomeFirstResponder()
        case lastNameTF: bornDateTF.becomeFirstResponder()
        default: textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - Keyboard Notifications

extension FirstRegistrViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(FirstRegistrViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FirstRegistrViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 || bornDateTF.isEditing {
                self.view.frame.origin.y = 0 - keyboardSize.height
            } else if !bornDateTF.isEditing {
                self.view.frame.origin.y = 0 - keyboardSize.height
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

// MARK: - Image Picker Avatar

extension FirstRegistrViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        dismiss(animated: true)
    }
    
    private func setupImageView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        imageView.image = UIImage(named: kImageNameAvatar)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(recognizer)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 100
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = Colors.niceWhite.cgColor
        imageView.clipsToBounds = true
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: kAlertTitleCamera, style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        let photo = UIAlertAction(title: kAlertTitleGallery, style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: kAlertTitleCancel, style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
}

