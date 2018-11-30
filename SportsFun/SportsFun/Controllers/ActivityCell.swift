//
//  ActivityCell.swift
//  SportsFun
//
//  Created by benjamin malbrel on 26/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    @IBOutlet weak var ivGameImage: UIImageView!
    @IBOutlet weak var lType: UILabel!
    @IBOutlet weak var lDate: UILabel!
    @IBOutlet weak var lTemps: UILabel!
 
    func setCell(activity: Activity) {
        if let index = activity.date.range(of: "T")?.lowerBound {
            let substring = activity.date[..<index]
            let string = String(substring)
            let dateArr = string.characters.split{$0 == "-"}.map(String.init)
            self.lType.text = "Score : \(activity.score)"
            self.lDate.text = "le : \(dateArr[2])/\(dateArr[1])/\(dateArr[0])"
            if activity.timeSpent < 60 {
                 self.lTemps.text = "pendant \(activity.timeSpent) secondes"
            } else {
                self.lTemps.text = "pendant \(activity.timeSpent / 60) minutes"
            }
        }
        
    }
}
