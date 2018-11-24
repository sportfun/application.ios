//
//  NewCommentCell.swift
//  SportsFun
//
//  Created by benjamin malbrel on 22/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

protocol NewCommentCellDelegate {
    func didTapSend(newComment: String)
}

class NewCommentCell: UITableViewCell {
    @IBOutlet weak var tfComment: UITextField!
    @IBOutlet weak var bSend: UIButton!
    var delegate : NewCommentCellDelegate?

    @IBAction func send(_ sender: UIButton) {
        delegate?.didTapSend(newComment: self.tfComment.text!)
        tfComment.text = ""
    }
}
