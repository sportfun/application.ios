//
//  Account.swift
//  SportsFun
//
//  Created by benjamin malbrel on 18/05/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class Account : UITableViewController {
    @IBAction func clicSurDeconnexion(sender: UIButton) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("token.txt")
            do {
                try FileManager.default.removeItem(at: fileURL)
                let fileURL = documentDirectory.appendingPathComponent("id.txt")
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    let storyboard = UIStoryboard(name: "LoginRegister", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Login")
                    self.present(vc, animated: true, completion: nil)
                } catch let error as NSError {
                    print("Error: \(error.domain)")
                }
            } catch let error as NSError {
                print("Error: \(error.domain)")
            }
            
        }
    }
}
