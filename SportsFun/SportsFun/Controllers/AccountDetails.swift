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
    @IBOutlet var userName : UITextField!
    @IBOutlet var firstName : UITextField!
    @IBOutlet var lastName : UITextField!
    var networking: Networking
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
                        self.userName.text = self.userInfo.username
                        self.firstName.text = self.userInfo.firstName
                        self.lastName.text = self.userInfo.lastName
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
    }
}
