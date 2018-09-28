//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Jason Goodney on 9/28/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    // MARK: - Properties
    var isUpdating = false
    var contact: Contact? {
        didSet {
            updateTextFields()
        }
    }
    
    private var name: String? {
        get {
            return contentView.nameTextField.text
        }
        set (newName) {
            saveButton.isEnabled = true
            contentView.nameTextField.text = newName
        }
    }
    
    private var phone: String? {
        get {
            return contentView.phoneTextField.text
        }
        set (newPhone) {
            contentView.phoneTextField.text = newPhone
        }
    }
    
    private var email: String? {
        get {
            return contentView.emailTextField.text
        }
        set (newEmail) {
            contentView.emailTextField.text = newEmail
        }
    }
    
    // MARK: - Subviews
    lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButtonTapped))
    
    var contentView: ContactDetailView {
        return view as! ContactDetailView
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = ContactDetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        
        saveButton.isEnabled = false
        
        contentView.nameTextField.delegate = self
        contentView.phoneTextField.delegate = self
        contentView.emailTextField.delegate = self
    }
}

// MARK: - UI
private extension ContactDetailViewController {
    func updateView() {
        
        setupNavigationBar()
    }
    
    func setupConstraints() {
        
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = saveButton
        
        guard let contact = contact else { return }
        title = contact.name
    }
    
    func updateTextFields() {
        guard let contact = contact else { return }
        name = contact.name
        phone = contact.phone
        email = contact.email
    }
}

// MARK: - UserInteraction
private extension ContactDetailViewController {
    @objc func saveButtonTapped() {
        guard let name = name?.trimmingCharacters(in: .whitespaces), !name.isEmpty,
            let phone = phone?.trimmingCharacters(in: .whitespaces),
            let email = email?.trimmingCharacters(in: .whitespaces) else { return }
        
        if isUpdating {
            guard let contact = contact else { return }
            ContactController.shared.updateContact(contact, name: name, phone: phone, email: email) { (success) in
                if success {
                    print("Updated contact")
                }
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            ContactController.shared.addContact(name: name, email: email, phone: phone) { (contact) in
                print("added a new contact")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension ContactDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let initialText = textField.text
        
        let changedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if changedText != initialText {
            saveButton.isEnabled = true
    
        }
        
        return true
    }
}
