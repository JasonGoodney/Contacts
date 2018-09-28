//
//  Contact.swift
//  Contacts
//
//  Created by Jason Goodney on 9/28/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation
import CloudKit

struct ContactKey {
    static let RecordType = "Contact"
    
    static let NameKey = "Name"
    static let PhoneKey = "Phone"
    static let EmailKey = "Email"
}

class Contact {
    
    var name: String
    var phone: String
    var email: String
    var recordId: CKRecord.ID
    
    init(name: String, phone: String, email: String,
         recordId: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.name = name
        self.phone = phone
        self.email = email
        self.recordId = recordId
    }
    
    convenience init?(record: CKRecord) {
        guard let email = record[ContactKey.EmailKey] as? String,
            let name = record[ContactKey.NameKey] as? String,
            let phone = record[ContactKey.PhoneKey] as? String else { return nil }
        
        self.init(name: name, phone: phone, email: email)
        self.recordId = record.recordID
    }
    
}

extension CKRecord {
    
    convenience init(contact: Contact) {
        self.init(recordType: ContactKey.RecordType, recordID: contact.recordId)
        
        self.setValue(contact.name, forKey: ContactKey.NameKey)
        self.setValue(contact.phone, forKey: ContactKey.PhoneKey)
        self.setValue(contact.email, forKey: ContactKey.EmailKey)
    }
}
