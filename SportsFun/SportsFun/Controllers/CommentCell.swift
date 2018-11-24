//
//  CommentCell.swift
//  SportsFun
//
//  Created by benjamin malbrel on 18/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit


class CommentCell: UITableViewCell {
    var comment: Comment?
    @IBOutlet weak var lAuthor: UILabel!
    @IBOutlet weak var lContent: UILabel!
    
    func setComment(comment: Comment) {
        self.comment = comment
        lAuthor.text = comment.author.firstName + " " + comment.author.lastName
        lContent.text = comment.content
    }
}
