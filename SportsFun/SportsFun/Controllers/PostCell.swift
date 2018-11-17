//
//  PostCell.swift
//  SportsFun
//
//  Created by benjamin malbrel on 17/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

protocol PostCellDelegate {
    func didTapLike(post: Post)
    func didTapComment(post: Post)
}

class PostCell: UITableViewCell {
    var post: Post?
    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var lContent: UILabel!
    @IBOutlet weak var bLike: UIButton!
    @IBOutlet weak var bComment: UIButton!
    var delegate : PostCellDelegate?
    
    func setPost(post: Post) {
        self.post = post
        lName.text = post.author.firstName + " " + post.author.lastName
        lContent.text = post.content
        for like in (self.post?.likes)! {
            if like == myID {
                bLike.setTitleColor(UIColor.orange, for: .normal)
            }
        }
    }
    
    @IBAction func like(_ sender: UIButton) {
        delegate?.didTapLike(post: self.post!)
        if sender.titleColor(for: .normal) == UIColor.orange {
            bLike.setTitleColor(UIColor.black, for: .normal)
        } else {
            bLike.setTitleColor(UIColor.orange, for: .normal)
        }
    }
    
    @IBAction func comment(_ sender: UIButton) {
        delegate?.didTapComment(post: self.post!)
    }
}
