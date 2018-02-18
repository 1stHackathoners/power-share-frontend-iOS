//
//  DataClasses.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import Foundation
import CoreLocation

class User{
    let username: String
    let password: String
    var totalCredit: Double
    
    init(username: String, password: String, totalCredit: Double) {
        self.username = username
        self.password = password
        self.totalCredit = totalCredit
    }
}

struct TotalCost{
    var startTime: Date
    var endTime: Date
    var totalCost: Double
    
    func calculateCost(){
        
    }
    
}
