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
    @IBOutlet var lError: UILabel!
    var IPAdress : String
    let networking : Networking
    
    required init?(coder decoder: NSCoder) {
        self.IPAdress = "http://149.202.41.22:8080"
        self.networking = Networking()
        
        super.init(coder : decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lError.text = ""
    }
    
    @IBAction func clicConfirm(sender : UIButton) {
        let stringFromDate = dpBirthdate.date.iso8601
        lError.text = ""
        if let birthDate = stringFromDate.dateFromISO8601 {
            if let userName = tfUserName.text, let email = tfEmail.text, let firstName = tfFirstName.text, let lastName = tfLastName.text, let password = tfPassword.text , userName != "" && email != "" && firstName != "" && lastName != "" && password != "" {
                print("bb\(birthDate)")
                let url : String =  "\(self.IPAdress)/api/user"
                let param : String = "username=\(userName)&email=\(email)&firstName=\(firstName)&lastName=\(lastName)&birthDate=\(birthDate.iso8601)&password=\(password)&bio=\"\"&coverPic=\"\"&profilePic=\"\"&roles=[]&goal=0"
                print(param)
                self.networking.querryWithPost(urlString : url, param: param) { data in
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let parsedRegister = try decoder.decode(Login.self, from: data)
                            print(parsedRegister)
                            if parsedRegister.success == false {
                                self.lError.text = parsedRegister.message
                            } else {
                                //TODO : faire la connexion et établir un moyen d'ouvrir la fenetre d'après
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                print("not ok")
            }
        }
    }
}
