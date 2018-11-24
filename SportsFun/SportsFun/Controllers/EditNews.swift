//
//  createNews.swift
//  SportsFun
//
//  Created by benjamin malbrel on 12/09/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation
import UIKit

class EditNews : UIViewController {
    var comments : [Comment] = []
    let networking : Networking
    var postID:String = ""
    
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
        
        print(postID)
        getComments()
        self.hideKeyboardWhenTappedAround()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.tableFooterView = UIView()
    }
    
    func getComments() {
        let url : String = "/post/comments/\(postID)"
        self.networking.querryWithGet(urlString: url) { data in
            if let data = data {
                do {
                    let commentsData = try JSONDecoder().decode(CommentsData.self, from: data)
                    if commentsData.success == false {
                        print(commentsData.message)
                    } else {
                        self.comments = commentsData.data!
                        self.tableView.reloadData()
                    }
                } catch {
                    print("error:", error)
                }
            }
        }
    }
}

extension EditNews: NewCommentCellDelegate {
    func didTapSend(newComment: String) {
        if newComment != "" {
            let url : String =  "/post"
            let param : String = "content=\(newComment)&parent=\(self.postID)"
            self.networking.querryWithPostWithToken(urlString : url, param: param) { data in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(NewPost.self, from: data)
                        if response.success == false {
                            print("response new comment")
                            print(response.message)
                        } else {
                            self.getComments()
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

extension EditNews: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == comments.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewCommentCell") as! NewCommentCell
            
            cell.delegate = self
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        } else {
            let comment = self.comments[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            cell.setComment(comment: comment)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
}
