//
//  Networking.swift
//  SportsFun
//
//  Created by benjamin malbrel on 16/03/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

class Networking {
    typealias QuerryResult = (Data?) -> ()
    
    func querryWithPost(urlString : String, param: String, completion: @escaping QuerryResult) {
        let url = URL(string: "\(urlString)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let param = "\(param)"
        request.httpBody = param.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
    
    func querryWithGet(urlString : String, token: String, completion: @escaping QuerryResult) {
        let url = URL(string: "\(urlString)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("\(token)", forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("prout")
                return
            }
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(String(describing: responseString))")
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
}
