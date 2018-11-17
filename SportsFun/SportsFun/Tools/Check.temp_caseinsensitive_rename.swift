//
//  check.swift
//  SportsFun
//
//  Created by benjamin malbrel on 02/11/2018.
//  Copyright © 2018 benjamin malbrel. All rights reserved.
//

import Foundation

class Check {
    init() {}
    
    func checkPassword(password: String) -> boolean {
        let ret: boolean = false;
        if (password.length >= 8) {
            ret = true;
        }
        return ret;
    }
}
