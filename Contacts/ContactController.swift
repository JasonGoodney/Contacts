//
//  ContactController.swift
//  Contacts
//
//  Created by Jason Goodney on 9/28/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    // MARK: - Properties
    static let shared = ContactController(); private init() {}
    
    let contactsWereUpdatedNotification = Notification.Name("ContactsWereUpdated")
    
    let pubDB = CKContainer.default().publicCloudDatabase
    
    var contacts: [Contact] = [] {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.contactsWereUpdatedNotification, object: nil)
            }
        }
    }
    
    
    // MARK: - Save
    func addContact(name: String, email: String, phone: String, completion: @escaping (Contact) -> Void) {
        
        let contact = Contact(name: name, phone: phone, email: email)
        
        let record = CKRecord(contact: contact)
        
        pubDB.save(record) { (record, error) in
            if let error = error {
                print("🐙Error in function: \(#function) \(error) \(error.localizedDescription)")
                return
            }
            
            guard let record = record else { return }
            guard let contact = Contact(record: record) else { return }
            completion(contact)
        }
    }
    
}
