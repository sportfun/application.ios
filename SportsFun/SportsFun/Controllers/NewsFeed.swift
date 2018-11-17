//
//  NewsFeed.swift
//  SportsFun
//
//  Created by benjamin malbrel on 22/05/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

var myID : String = ""

class NewsFeed : UIViewController {
    var posts: [Post] = []
    var networking: Networking
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
        
        let addButton = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 + self.view.frame.width / 3 , y: self.view.frame.size.height - 110), size: CGSize(width: 50, height: 50)))
        
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
        addButton.clipsToBounds = true
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        addButton.setTitle("+", for: UIControl.State.normal)
        addButton.backgroundColor = UIColor.orange
        self.navigationController?.view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(NewsFeed.addNews(_:)), for: .touchUpInside)
        self.getPosts()
    }
    
    @objc func addNews(_ sender : UIButton!) {
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "addNews") as UIViewController, animated: true)
    }
    
    func getPosts() {
        let url : String = "/post"
        self.networking.querryWithGet(urlString: url) { data in
            if let data = data {
                do {
                    let postData = try JSONDecoder().decode(PostsData.self, from: data)
                    if postData.success == false {
                        print(postData.message)
                    } else {
                        self.posts = postData.data!
                        self.tableView.reloadData()
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
    }
}

extension NewsFeed: PostCellDelegate {    
    func didTapLike(post: Post){
        let url : String = "/post/like/\(post._id)"
        self.networking.querryWithPut(urlString: url, param: "") { data in
            if let data = data {
                do {
                    let likeData = try JSONDecoder().decode(Passwd.self, from: data)
                    if likeData.success == false {
                        print(likeData.message)
                    } else {
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
    }
    
    func didTapComment(post: Post) {
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "editNews") as UIViewController, animated: true)
    }
}

extension NewsFeed: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = self.posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        cell.setPost(post: post)
        cell.delegate = self
        
        return cell
    }
}
