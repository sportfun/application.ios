//
//  SummaryActivity.swift
//  SportsFun
//
//  Created by benjamin malbrel on 25/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

class SummaryActivity: UITableViewCell {
    
    @IBOutlet weak var vLeftRect: UIView!
    @IBOutlet weak var vRightRect: UIView!
    @IBOutlet weak var lDoneActivity: UILabel!
    @IBOutlet weak var lShouldActivity: UILabel!
    @IBOutlet weak var lPercentage: UILabel!
    @IBOutlet weak var pvPercentage: UIProgressView!
    
    func setCell(userInfo: userInfoData, activities: [Activity]) {
        var done: Int = 0
        var donePercent: Int = 0
        var donePercentFloat: Float = 0
        
        self.lShouldActivity.text = String(userInfo.goal)
        for activity in activities {
            done += activity.timeSpent/60
        }
        donePercent = done * 100 / userInfo.goal
        donePercentFloat = Float(donePercent) / Float(100)
        self.lDoneActivity.text = String(done)
        self.lPercentage.text = String(donePercent) + " %"
        print(donePercentFloat)
        self.pvPercentage.progress = donePercentFloat
    }
    
}
