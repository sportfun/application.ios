//
//  Networking.swift
//  SportsFun
//
//  Created by benjamin malbrel on 16/03/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

// if request is not working past these 2 lines before dispatchQueue.main.async
//                        let responseString = String(data: data, encoding: .utf8)
//                        print("responseString = \(String(describing: responseString))")

class Networking {
    typealias QuerryResult = (Data?) -> ()
    var token : String
    let IPAdress : String
    
    init(token: String) {
        self.token = token
        self.IPAdress = "http://api.sportsfun.shr.ovh:8080/api"
    }
    
    func querryWithPut(urlString : String, param: String, completion: @escaping QuerryResult) {
        let url = URL(string: "\(self.IPAdress)\(urlString)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("\(self.token)", forHTTPHeaderField: "token")
        request.httpMethod = "PUT"
        let param = "\(param)"
        request.httpBody = param.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("no connection detected: ", error!)
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
    
    func querryWithPost(urlString : String, param: String, completion: @escaping QuerryResult) {
        let url = URL(string: "\(self.IPAdress)\(urlString)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let param = "\(param)"
        request.httpBody = param.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("no connection detected: ", error!)
                return
            }
            print(urlString)
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
    
    func querryWithPostWithToken(urlString : String, param: String, completion: @escaping QuerryResult) {
        let url = URL(string: "\(self.IPAdress)\(urlString)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("\(self.token)", forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        let param = "\(param)"
        request.httpBody = param.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("no connection detected: ", error!)
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
    
    func querryWithGet(urlString : String, completion: @escaping QuerryResult) {
        let url = URL(string: "\(self.IPAdress)\(urlString)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("\(self.token)", forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("no connection detected: ", error!)
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
    
    func querryWithLock(urlString : String, param: String, completion: @escaping QuerryResult) {
        let url = URL(string: "\(self.IPAdress)\(urlString)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "LOCK"
        let param = "\(param)"
        request.httpBody = param.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("no connection detected: ", error!)
                return
            }
            print(urlString)
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
}
