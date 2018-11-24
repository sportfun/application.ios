//
//  File.swift
//  SportsFun
//
//  Created by benjamin malbrel on 18/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

struct CommentsData: Decodable {
    let success : Bool
    let message : String
    let data : [Comment]?
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }
}

struct Comment: Decodable {
    let _id : String
    let parent: String
    let content : String
    let likes : [String]?
    let author : Author
    
    private enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case parent = "parent"
        case content = "content"
        case likes = "likes"
        case author = "author"
    }
}
