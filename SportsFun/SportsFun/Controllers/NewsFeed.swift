//
//  NewsFeed.swift
//  SportsFun
//
//  Created by benjamin malbrel on 22/05/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class NewsFeed : UITableViewController {
    var posts : [Post]?
    var networking : Networking
    
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
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 178
        tableView.rowHeight = 178
        
        var url : String = "/post"
        self.networking.querryWithGet(urlString: url) { data in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let postData = try decoder.decode(PostData.self, from: data)
                    if postData.success == false {
                        print(postData.message)
                    } else {
                        self.posts = postData.data!
                        self.tableView.reloadData()
                        url = "/user"
                        self.networking.querryWithGet(urlString: url) { data in
                            if let data = data {
                                do {
                                    let parsedUser = try decoder.decode(UserInfo.self, from: data)
                                    if parsedUser.success == false {
                                        print(parsedUser.message)
                                    } else {
                                        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                                            let fileURL = documentDirectory.appendingPathComponent("id.txt")
                                            try parsedUser.data?._id.write(to: fileURL, atomically: false, encoding: .utf8)
                                        }
                                    }
                                } catch {
                                    print("error:", error)
                                }
                            }
                        }
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
    }
}

extension NewsFeed {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        cell.post = self.posts?[indexPath.row]
        
        return cell
    }
}
