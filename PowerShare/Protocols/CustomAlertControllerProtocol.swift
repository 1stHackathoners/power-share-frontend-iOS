//
//  CustomAlertControllerProtocol.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import Foundation

protocol CustomAlertControllerDelegate {
    // option == 1 is for "do something purposes and option == 2 is for cancelling purposes
    func handleAlertOptionsForButtons(option: Int)
}

