//
//  DataClasses.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import Foundation

class User{
    let username: String
    let password: String
    let totalCredit: Int
    
    init(username: String, password: String, totalCredit: Int) {
        self.username = username
        self.password = password
        self.totalCredit = totalCredit
    }
}
