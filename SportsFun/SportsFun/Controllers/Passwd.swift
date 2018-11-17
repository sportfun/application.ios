//
//  Password.swift
//  SportsFun
//
//  Created by benjamin malbrel on 11/05/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class Password : UIViewController {
    @IBOutlet var tPPassword : UITextField!
    @IBOutlet var tNPassword : UITextField!
    @IBOutlet var tRPassword : UITextField!
    @IBOutlet var lError : UILabel!
    
    let networking : Networking
    let check : Check
    var userInfo : userInfoData!
 
    required init?(coder decoder: NSCoder) {
        self.networking = Networking(token: "")
        self.check = Check()
        do {
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("token.txt")
                let token = try String(contentsOf: fileURL)
                self.networking.token = token
            }
        } catch {
            print("error:", error)
        }
        
        super.init(coder : decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lError.text = ""
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func clicConfirmer(sender: UIButton) {
        if let pPassword = tPPassword.text, let nPassword = tNPassword.text, let RPassword = tRPassword.text, pPassword != "" && nPassword != "" && RPassword != "" && self.check.chekPassword(password: nPassword) {
            if nPassword == RPassword {
                let url : String =  "/user/password"
                let param : String = "password=\(pPassword)&newPassword=\(nPassword)"
                self.networking.querryWithPut(urlString : url, param: param) { data in
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let parsedPassword = try decoder.decode(Passwd.self, from: data)
                            if parsedPassword.success == false {
                                self.lError.text = parsedPassword.message
                            }
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                lError.text = "les nouveaux mots de passe ne sont pas identiques"
            }
        } else {
            lError.text = "Une longueur minimale de 8 caractères est attendu pour votre mot de passe"
        }
    }
    
}
