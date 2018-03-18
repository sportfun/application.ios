//
//  Connexion.swift
//  SportsFun
//
//  Created by benjamin malbrel on 09/03/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class Connexion : UIViewController {
    
    @IBOutlet var tfUserName : UITextField!
    @IBOutlet var tfPassword : UITextField!
    @IBOutlet var bConnection : UIButton!
    @IBOutlet var lError : UILabel!
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
    
    @IBAction func clicConnexion(sender : UIButton) {
        lError.text = ""
        if let userName = tfUserName.text, let password = tfPassword.text, userName != "" && password != "" {
            var url : String =  "\(self.IPAdress)/api/user/login"
            var param : String = "username=\(userName)&password=\(password)"
            self.networking.querryWithPost(urlString : url, param: param) { data in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let parsedLogin = try decoder.decode(Login.self, from: data)
                        if parsedLogin.success == false {
                            self.lError.text = parsedLogin.message
                        } else {
                            if let token = parsedLogin.data?.token {
                                url = "\(self.IPAdress)/api/user"
                                param = "\(token)"
                                self.networking.querryWithGet(urlString: url, token: param) { data in
                                    if let data = data {
                                        do {
                                            let parsedUser = try decoder.decode(UserInfo.self, from: data)
                                            if parsedUser.success == false {
                                                self.lError.text = "Une erreur c'est produite lors de votre connexion veuillez patienter"
                                            } else {
                                                print(parsedUser)
                                                if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                                                    let fileURL = documentDirectory.appendingPathComponent("token.txt")
                                                    try token.write(to: fileURL, atomically: false, encoding: .utf8)
                                                    // reading from disk
//                                                    let savedText = try String(contentsOf: fileURL)
//                                                    print("savedText:", savedText)
                                                    //TODO : faire la connexion et établir un moyen d'ouvrir la fenetre d'après
                                                }
                                            }
                                        } catch {
                                            print("error:", error)
                                        }
                                    }
                                }
                            }
                        }
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            
        }
    }
    
}
