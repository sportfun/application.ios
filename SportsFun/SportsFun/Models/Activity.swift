//
//  Activities.swift
//  SportsFun
//
//  Created by benjamin malbrel on 25/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

struct ActivitiesData: Decodable {
    let success : Bool
    let message : String
    let data : [Activity]?
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }
}

struct Activity: Decodable {
    let _id : String
    let type : String
    let timeSpent : Int
    let score : Int
    
    private enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case type = "type"
        case timeSpent = "timeSpent"
        case score = "score"
    }
}
