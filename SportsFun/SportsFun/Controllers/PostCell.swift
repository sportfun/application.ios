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
    var myLike: Bool = false;
    var delegate : PostCellDelegate?
    
    func setPost(post: Post) {
        self.post = post
        lName.text = post.author.firstName + " " + post.author.lastName
        lContent.text = post.content
        for like in (self.post?.likes)! {
            if like == myID {
                myLike = true
                bLike.setTitleColor(hexStringToUIColor(hex: "e2912e"), for: .normal)
                bLike.tintColor = hexStringToUIColor(hex: "e2912e");
            }
        }
    }
    
    @IBAction func like(_ sender: UIButton) {
        delegate?.didTapLike(post: self.post!)
        if myLike == true {
            myLike = false
            bLike.setTitleColor(UIColor.black, for: .normal)
            bLike.tintColor = UIColor.black;
        } else {
            myLike = true
            bLike.setTitleColor(hexStringToUIColor(hex: "e2912e"), for: .normal)
            bLike.tintColor = hexStringToUIColor(hex: "e2912e");
        }
    }
    
    @IBAction func comment(_ sender: UIButton) {
        delegate?.didTapComment(post: self.post!)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
