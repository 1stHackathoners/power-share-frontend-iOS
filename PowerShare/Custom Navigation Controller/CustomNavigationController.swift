//
//  CustomNavigationController.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor.green
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
