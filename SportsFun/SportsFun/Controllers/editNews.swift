//
//  createNews.swift
//  SportsFun
//
//  Created by benjamin malbrel on 12/09/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class editNews : UIViewController {
    let networking : Networking
    
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
        
        self.hideKeyboardWhenTappedAround()
    }
}
