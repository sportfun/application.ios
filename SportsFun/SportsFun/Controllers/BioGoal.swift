//
//  Bio.swift
//  SportsFun
//
//  Created by benjamin malbrel on 14/05/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class BioGoal : UIViewController {
    @IBOutlet var tvBio : UITextView!
    @IBOutlet var tfGoal : UITextField!
    @IBOutlet var lError : UILabel!
    @IBOutlet var bConfirm : UIButton!
    
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
        tvBio.layer.cornerRadius = 5
        tvBio.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        tvBio.layer.borderWidth = 0.5
        tvBio.clipsToBounds = true
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
                        self.tfGoal.text = String(self.userInfo.goal)
                        self.tvBio.text = self.userInfo.bio
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
        lError.text = ""
    }
    
    @IBAction func clicConfirmer(sender : UIButton) {
        lError.text = ""
        if let goal = Int(tfGoal.text!), let bio = tvBio.text, bio != "" {
            let url : String =  "/user"
            let param : String = "username=\(self.userInfo.username)&email=\(self.userInfo.email)&firstName=\(self.userInfo.firstName)&lastName=\(self.userInfo.lastName)&birthDate=\(self.userInfo.birthDate)&bio=\(bio)&coverPic=\"\"&profilePic=\"\"&roles=[]&goal=\(goal)"
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
            lError.text = "Tous les champs doivent être remplies"
        }
    }
}
