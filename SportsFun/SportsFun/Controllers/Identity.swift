//
//  Identity.swift
//  SportsFun
//
//  Created by benjamin malbrel on 11/05/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class Identity : UIViewController {
    @IBOutlet var tfFirstName : UITextField!
    @IBOutlet var tfLastName : UITextField!
    @IBOutlet var tfMail : UITextField!
    @IBOutlet var lError : UILabel!
    @IBOutlet var bConfirm: UIButton!
    
    let networking : Networking
    var userInfo : userInfoData!
    
    required init?(coder decoder: NSCoder) {
        self.networking = Networking(token: "")
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
        
        bConfirm.layer.cornerRadius = 10
        bConfirm.clipsToBounds = true
        self.hideKeyboardWhenTappedAround()
        let url : String = "/user"
        self.networking.querryWithGet(urlString: url) { data in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let userInfo = try decoder.decode(UserInfo.self, from: data)
                    if userInfo.success == false {
                        self.lError.text = "Problème de connexion avec le serveur"
                    } else {
                        self.userInfo = userInfo.data
                        if (self.userInfo.bio == "\"\"") {
                            self.userInfo.bio.removeFirst()
                            self.userInfo.bio.removeLast()
                        }
                        self.tfLastName.text = self.userInfo.lastName
                        self.tfFirstName.text = self.userInfo.firstName
                        self.tfMail.text = self.userInfo.email
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
        
        lError.text = ""
    }

    @IBAction func clicConfirmer(sender: UIButton) {
        if let firstName = tfFirstName.text, let lastName = tfLastName.text, let mail = tfMail.text, firstName != "" && lastName != "" && mail != "" {
            let url : String =  "/user"
          let hashString = mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().md5()
          let profilePic = String(format: "https://www.gravatar.com/avatar/%@", hashString)
            let param : String = "username=\(self.userInfo.username)&email=\(mail)&firstName=\(firstName)&lastName=\(lastName)&birthDate=\(self.userInfo.birthDate)&bio=\(self.userInfo.bio)&coverPic=\"\"&profilePic=\(profilePic.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&roles=[]&goal=\(self.userInfo.goal)"
            self.networking.querryWithPut(urlString : url, param: param) { data in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let parsedPassword = try decoder.decode(Passwd.self, from: data)
                        if parsedPassword.success == false {
                            self.lError.text = parsedPassword.message
                        } else {
                            self.lError.text = "Success !"
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            lError.text = "tous les champs doivent être remplis"
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
