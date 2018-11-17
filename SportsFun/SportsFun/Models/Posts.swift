//
//  Post.swift
//  SportsFun
//
//  Created by benjamin malbrel on 21/05/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

struct PostsData: Decodable {
    let success : Bool
    let message : String
    let data : [Post]?
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }
}

struct Post: Decodable {
    let _id : String
    let likes : [String]?
    let comments : [String]?
    let content : String
    let author : Author
    
    private enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case likes = "likes"
        case comments = "comments"
        case content = "content"
        case author = "author"
    }
}

struct Author: Decodable {
    let firstName : String
    let lastName : String
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "firstName"
        case lastName = "lastName"
    }
}
