//
//  RequestAnswer.swift
//  SportsFun
//
//  Created by benjamin malbrel on 17/03/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

struct Login: Decodable {
    let success : Bool
    let message : String
    let data : LoginData?
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }
}

struct LoginData: Decodable {
    let token : String
    
    private enum CodingKeys: String, CodingKey {
        case token = "token"
    }
}
