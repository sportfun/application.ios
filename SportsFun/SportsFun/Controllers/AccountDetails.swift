//
//  AccountDetails.swift
//  SportsFun
//
//  Created by benjamin malbrel on 21/03/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class AccountDetails: UIViewController {
    @IBOutlet var tfUserName : UITextField!
    @IBOutlet var tfEmail : UITextField!
    @IBOutlet var tfFirstName : UITextField!
    @IBOutlet var tfLastName : UITextField!
    @IBOutlet var tfBio : UITextField!
    @IBOutlet var tfGoal : UITextField!
    
    var networking: Networking
    var userInfo : userInfoData!
    
    required init?(coder decoder: NSCoder) {
        print("prout")
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
        print("caca")
        super.viewDidLoad()
        
        let url : String = "/user"
        self.networking.querryWithGet(urlString: url) { data in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let userInfo = try decoder.decode(UserInfo.self, from: data)
                    if userInfo.success == false {
                       print("")
                    } else {
                        self.userInfo = userInfo.data
                        self.tfUserName.text = self.userInfo.username
                        self.tfEmail.text = self.userInfo.email
                        self.tfFirstName.text = self.userInfo.firstName
                        self.tfLastName.text = self.userInfo.lastName
                        self.tfGoal.text = String(self.userInfo.goal)
                        self.tfBio.text = self.userInfo.bio
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
    }
}
