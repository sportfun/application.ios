//
//  Session.swift
//  SportsFun
//
//  Created by benjamin malbrel on 25/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import UIKit

class Session: UIViewController {
    let networking : Networking
    var userInfo : userInfoData!
    var activities : [Activity] = []
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.getGoal()
        self.getActivities()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getGoal()
        self.getActivities()
    }
    
    func getGoal() {
        let url : String = "/user"
        self.networking.querryWithGet(urlString: url) { data in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let userInfo = try decoder.decode(UserInfo.self, from: data)
                    if userInfo.success == false {
                        print("Problème de connexion avec le serveur")
                    } else {
                        self.userInfo = userInfo.data!
                        self.tableView.reloadData()
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
    }
    
    func getActivities() {
        let url : String = "/activity"
        self.networking.querryWithGet(urlString: url) { data in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let activities = try decoder.decode(ActivitiesData.self, from: data)
                    if activities.success == false {
                        print("Problème de connexion avec le serveur")
                    } else {
                        self.activities = activities.data!
                        self.tableView.reloadData()
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
    }
}

extension Session: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((self.userInfo) != nil) {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryActivity") as! SummaryActivity
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setCell(userInfo: self.userInfo, activities: self.activities)
        
        return cell
        //        if (indexPath.row == 0) {
//            
//        } else {
//            print("prout")
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryActivity") as! SummaryActivity
//
//
//            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
}
