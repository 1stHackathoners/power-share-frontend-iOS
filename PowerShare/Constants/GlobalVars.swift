//
//  GlobalVars.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit

var alert: CustomAlertController!
var currentylActiveKeyboard: UITextField?
var keyboardHeight: CGFloat!
let emptySpacePt: CGFloat = 35

var counterLabel: UILabel = {
    let label = UILabel()
    return label
}()

let refreshIndicator: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.activityIndicatorViewStyle = .white
    activityIndicatorView.color = UIColor.white
    activityIndicatorView.hidesWhenStopped = true
    return activityIndicatorView
}()

let loadingView: UIView = {
    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    view.alpha = 0
    view.addSubview(refreshIndicator)
    NSLayoutConstraint.activate([
        refreshIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        refreshIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        refreshIndicator.heightAnchor.constraint(equalToConstant: 40),
        refreshIndicator.widthAnchor.constraint(equalToConstant: 40)
        ])
    return view
}()
