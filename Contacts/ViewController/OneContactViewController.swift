//
//  OneContactViewController.swift
//  Contacts
//
//  Created by Jason Goodney on 9/28/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class OneContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func continueButton(_ sender: Any) {
        let listVC = ContactListViewController()
        UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: ContactListViewController())
    }
    
}
