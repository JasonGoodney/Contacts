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
    
    let privateDB = CKContainer.default().privateCloudDatabase
    
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
        
        privateDB.save(record) { (record, error) in
            if let error = error {
                print("🐙Error in function: \(#function) \(error) \(error.localizedDescription)")
                return
            }
            
            guard let record = record else { return }
            guard let contact = Contact(record: record) else { return }
            if let index = self.contacts.firstIndex(where: { $0.name > contact.name }) {
                self.contacts.insert(contact, at: index)
            }
            completion(contact)
        }
    }
    
    // MARK: - Fetch
    func fetchContacts(completion: @escaping ([Contact]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: ContactKey.RecordType, predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: "Name", ascending: true)]
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("🐙Error in function: \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let records = records else {
                completion(nil)
                return
            }
            
            self.contacts = records.compactMap { Contact(record: $0) }
            
            completion(self.contacts)
        }
    }
    
    // MARK: - Update
    func updateContact(_ contact: Contact, name: String, phone: String, email: String,
                       completion: @escaping (Bool) -> Void) {
        
        contact.name = name
        contact.phone = phone
        contact.email = email
        
        let record = CKRecord(contact: contact)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInitiated
        operation.completionBlock = {
            completion(true)
        }
        
        privateDB.add(operation)
    }
    
    
    
}
