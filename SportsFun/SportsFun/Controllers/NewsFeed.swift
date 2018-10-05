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
        
        let addButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 + self.view.frame.width / 3 , y: self.view.frame.size.height - 110), size: CGSize(width: 50, height: 50)))
        
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
        addButton.clipsToBounds = true
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        addButton.setTitle("+", for: UIControl.State.normal)
        addButton.backgroundColor = UIColor.orange
        self.navigationController?.view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(NewsFeed.addNews(_:)), for: .touchUpInside)
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 178
        tableView.rowHeight = 178
        
        self.getPostsUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getPostsUpdate()
    }
    
    func getPostsUpdate() {
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
    
    @objc func addNews(_ sender : UIButton!) {
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "addNews") as UIViewController, animated: true)
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
