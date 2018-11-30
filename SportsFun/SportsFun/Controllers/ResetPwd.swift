//
//  ResetPwd.swift
//  SportsFun
//
//  Created by benjamin malbrel on 29/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

class ResetPwd: UIViewController {
    @IBOutlet weak var lUsername: UITextField!
    @IBOutlet weak var lEmail: UITextField!
    @IBOutlet weak var lError: UILabel!
    @IBOutlet weak var bConfirm: UIButton!
    let networking : Networking
    let check: Check
    
    required init?(coder decoder: NSCoder) {
        self.check = Check()
        self.networking = Networking(token: "")
        
        super.init(coder : decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bConfirm.layer.cornerRadius = 10
        bConfirm.clipsToBounds = true
        self.lError.text = ""
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func clicReset(sender: UIButton) {
        lError.text = ""
        if let username = lUsername.text, let email = lEmail.text, username != "" && email != ""{
            let url = "/user/password"
            let param = "username=\(username)&email=\(email)"
            self.networking.querryWithLock(urlString: url, param: param) { data in
                if let data = data {
                    do {
                        let parsedUser = try JSONDecoder().decode(UserInfo.self, from: data)
                        if parsedUser.success == false {
                            self.lError.text = parsedUser.message
                        } else {
                            // Create the alert controller
                            let alertController = UIAlertController(title: "Succès", message: "Votre mot de passe viens d'être réinitialiser veuillez consulter votre adresse mail", preferredStyle: .alert)
                            
                            // Create the actions
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                self.tabBarController!.selectedIndex = 0;
                                self.lEmail.text = ""
                                self.lUsername.text = ""
                            }
                            
                            // Add the actions
                            alertController.addAction(okAction)
                            
                            // Present the controller
                            self.present(alertController, animated: true, completion: nil)
                        }
                    } catch {
                        print("error:", error)
                    }
                }
            }
        } else {
            lError.text = "veuillez saisir tous les champs"
        }
    }
}
