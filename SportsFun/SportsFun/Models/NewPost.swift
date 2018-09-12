//
//  NewPost.swift
//  SportsFun
//
//  Created by benjamin malbrel on 12/09/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

struct NewPost: Decodable {
    let success : Bool
    let message : String
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
    }
}
