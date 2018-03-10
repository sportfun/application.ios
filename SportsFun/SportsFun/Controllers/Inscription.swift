//
//  Inscription.swift
//  SportsFun
//
//  Created by benjamin malbrel on 09/03/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

class Inscription : UIViewController {
    
    @IBOutlet var tfUserName : UITextField!
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfFirstName : UITextField!
    @IBOutlet var tfLastName : UITextField!
    @IBOutlet var tfPassword : UITextField!
    @IBOutlet var dpBirthdate : UIDatePicker!
    @IBOutlet var bConfirm : UIButton!
    @IBOutlet var bCancel : UIButton!
    
    @IBAction func clicConfirm(sender : UIButton) {
        let userName = tfUserName.text
        let email = tfEmail.text
        let firstName = tfFirstName.text
        let lastName = tfLastName.text
        let password = tfPassword.text
        let birthdate = dpBirthdate.date
        
        print(birthdate)
        if userName != "" && email != "" && firstName != "" && lastName != "" && password != "" {
            print("ok")
        } else {
            print("not ok")
        }
    }
}
