//
//  AccountCategoryCellTableViewCell.swift
//  SportsFun
//
//  Created by benjamin malbrel on 29/04/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

class AccountCategoryCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
