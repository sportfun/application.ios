//
//  Check.swift
//  SportsFun
//
//  Created by benjamin malbrel on 02/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

class Check {
    init () {}
    
  func chekPassword(password: String) -> Bool {
        return (password.count >= 8)
    }
    
    func checkUserName(userName: String) -> Bool {
        return (userName.count >= 3)
    }
    
    func checkMail(mail: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: mail)
    }
}
