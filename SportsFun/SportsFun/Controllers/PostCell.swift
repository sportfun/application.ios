//
//  PostCell.swift
//  SportsFun
//
//  Created by benjamin malbrel on 21/05/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class PostCell : UITableViewCell {
    @IBOutlet var lName : UILabel!
    @IBOutlet var lText : UILabel!
    @IBOutlet var lLikesNumber : UILabel!
    @IBOutlet var lCommentsNumber : UILabel!
    @IBOutlet var bLike : UIButton!
    
    var myID : String!
    var post : Post! {
        didSet {
            self.getID()
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.lName.text = "\(self.post.author.firstName) \(self.post.author.lastName)"
        self.lText.text = self.post.content
        if self.post.comments!.count > 1 {
            self.lCommentsNumber.text = "\(self.post.comments!.count) commentaires"
        } else {
            self.lCommentsNumber.text = "\(self.post.comments!.count) commentaire"
        }
        if self.post.likes!.count > 1 {
            self.lLikesNumber.text = "\(self.post.likes!.count) aiment ça"
        } else {
            self.lLikesNumber.text = "\(self.post.likes!.count) aime ça"
        }
        
        for like in self.post.likes! {
            if like == self.myID {
                print("prout")
                bLike.setTitleColor(UIColor.blue, for: .normal)
            }
        }
    }
    
    func getID() {
        do {
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("id.txt")
                let ID = try String(contentsOf: fileURL)
                self.myID = ID
            }
        } catch {
            print("error:", error)
        }
    }
}
