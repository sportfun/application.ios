//
//  userInfo.swift
//  SportsFun
//
//  Created by benjamin malbrel on 18/03/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

struct UserInfo: Decodable {
    let success : Bool
    let message : String
    let data : userInfoData?
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case data = "data"
    }
}

struct userInfoData: Decodable {
    var bio: String
    var profilePic: String
    var coverPic: String
    var goal: Int
    let _id: String
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var birthDate: String
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case bio = "bio"
        case profilePic = "profilePic"
        case coverPic = "coverPic"
        case goal = "goal"
        case _id = "_id"
        case username = "username"
        case email = "email"
        case firstName = "firstName"
        case lastName = "lastName"
        case birthDate = "birthDate"
        case password = "password"
    }
}
