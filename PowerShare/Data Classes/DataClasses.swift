//
//  DataClasses.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

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

class Stations{
    let name: String
    let location: CLLocation
    var availablePowerbankNum: Int
    var availableChargePortNum: Int
    let marker: GMSMarker
    
    
    
    init(name: String, location: CLLocation, availablePowerBankNum: Int, availableChargePortNum: Int, marker: GMSMarker) {
        self.name = name
        self.location = location
        self.availablePowerbankNum = availablePowerBankNum
        self.availableChargePortNum = availableChargePortNum
        self.marker = marker
    }
}

class TotalCost{
    var startTime: Date
    var endTime: Date
    var totalCost: Double!
    let costPerMinute: Double = 0.25 //TL
    
    init(startTime: Date, endTime: Date) {
        self.startTime = startTime
        self.endTime = endTime
        print(startTime)
        print(endTime)
        totalCost = (endTime.timeIntervalSince(startTime) / 60) * costPerMinute
    }
    
    func retrieveTotalCost() -> Double{
        return totalCost
    }
    
}
