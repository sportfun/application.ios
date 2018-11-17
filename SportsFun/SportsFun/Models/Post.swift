//
//  Post.swift
//  SportsFun
//
//  Created by benjamin malbrel on 28/10/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

struct PostData: Decodable {
    let success : Bool
    let message : String
    let data : Post?
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }
}
