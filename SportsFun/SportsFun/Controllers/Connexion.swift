//
//  Connexion.swift
//  SportsFun
//
//  Created by benjamin malbrel on 09/03/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

class Connexion : UIViewController {
    
    @IBOutlet var tfUserName : UITextField!
    @IBOutlet var tfPassword : UITextField!
    @IBOutlet var bConnection : UIButton!
    
    @IBAction func clicConnexion(sender : UIButton) {
        
        if let userName = tfUserName.text, let password = tfPassword.text, userName != "" && password != "" {
            let url = URL(string: "http://149.202.41.22:8080/api/user/login")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let postString = "username=\(userName)&password=\(password)"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    print("error=\(error as Optional)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response as Optional)")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString as Optional)")
            }
            task.resume()
        } else {
            
        }
    }
    
}
