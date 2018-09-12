//
//  createNews.swift
//  SportsFun
//
//  Created by benjamin malbrel on 12/09/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class createNews : UIViewController {
    @IBOutlet var tfContent : UITextField!
    @IBOutlet var bConfirmer : UIButton!
    @IBOutlet var lError : UILabel!
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
        
        tfContent.textAlignment = .left
        tfContent.contentVerticalAlignment = .top
        lError.text = ""
    }
    
    @IBAction func clicConfirmer(sender : UIButton) {
        if let content = tfContent.text, content != "" {
            let url : String =  "/post"
            let param : String = "content=\(content)"
            self.networking.querryWithPostWithToken(urlString : url, param: param) { data in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let parsedNewPost = try decoder.decode(NewPost.self, from: data)
                        if parsedNewPost.success == false {
                            self.lError.text = parsedNewPost.message
                        } else {
                            _ = self.navigationController?.popViewController(animated: true)
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
