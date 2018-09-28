//
//  ContactsListViewController.swift
//  Contacts
//
//  Created by Jason Goodney on 9/28/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController {
    
    // MARK: - Properties
    let cellId = String(describing: UITableViewCell.self)
    
    
    
    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return view
    }()
    
    lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    
    // MARK: - Lifcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        
        performFetch()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadContacts), name: ContactController.shared.contactsWereUpdatedNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Contacts"
        
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = "idk these peoeple"
    }
}

// MARK: - UpdateView
private extension ContactListViewController {
    func updateView() {
        addSubviews(subviews: [tableView])
        setupConstraints()
        setupNavigationBar()
    }
    
    func addSubviews(subviews: [UIView]) {
        subviews.forEach{ view.addSubview($0) }
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func setupNavigationBar() {

        navigationItem.rightBarButtonItem = addButton
        
    }

}

// MARK: - Methods
private extension ContactListViewController {
    @objc func reloadContacts() {
        
        self.tableView.reloadData()
    }
    
    func performFetch() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ContactController.shared.fetchContacts { (contacts) in
            guard let contacts = contacts else { return }
            ContactController.shared.contacts = contacts
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.reloadContacts()
            }
        }
    }
}

// MARK: - User Interaction
private extension ContactListViewController {
    
    @objc func addButtonTapped() {
        let contactDetailVC = ContactDetailViewController()
        navigationController?.pushViewController(contactDetailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = ContactController.shared.contacts[indexPath.row]
        let contactDetailVC = ContactDetailViewController()
        contactDetailVC.contact = contact
        contactDetailVC.isUpdating = true
        navigationController?.pushViewController(contactDetailVC, animated: true)
    }
}

