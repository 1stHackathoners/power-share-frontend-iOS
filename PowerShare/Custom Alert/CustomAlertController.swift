//
//  CustomAlertController.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit
import AudioToolbox

class CustomAlertController{
    
    //MARK: Properties
    
    let alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 100
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var demandButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 18)
        button.tintColor = UIColor.white
        button.tag = 1
        button.addTarget(self, action: #selector(handleOptions(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var dismisButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.green
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 18)
        button.tintColor = UIColor.white
        button.tag = 2
        button.addTarget(self, action: #selector(handleOptions(_:)), for: .touchUpInside)
        return button
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 30)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.green
        return label
    }()
    
    let descriptionTextView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 18)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.green
        label.minimumScaleFactor = 9 / label.font.pointSize
        label.numberOfLines = 5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    private var isVibrationEnabled: Bool
    private var alertOption: Bool!
    var controllingViewController: UIViewController!
    var windowWidth: CGFloat = 0
    let blackView = UIView()
    
    //MARK: Methods
    
    //Init 1 (with 1 button)
    init(message: String, description: String, buttonTitle: String, shouldVibrate: Bool){
        isVibrationEnabled = shouldVibrate
        alertOption = false
        
        //setting up message and description
        headerLabel.text = message
        descriptionTextView.text = description
        
        initializeHandlerWithCompletion(alertOption: alertOption, constraintOption: 1) {
            //adding views to their corresponding subviews
            demandButton.setTitle(buttonTitle, for: .normal)
            alertView.addSubview(demandButton)
        }
    }
    
    //Init 2 (with 2 buttons)
    init(message: String, description: String, dismissButtonName: String, demandButtonName: String, shouldVibrate: Bool, optionsHandlingViewController: UIViewController?){
        isVibrationEnabled = true
        alertOption = true
        if let optionsHandlingViewController = optionsHandlingViewController{
            self.controllingViewController = optionsHandlingViewController
            //setting up message and description
            headerLabel.text = message
            descriptionTextView.text = description
            
            initializeHandlerWithCompletion(alertOption: alertOption, constraintOption: 2) {
                alertView.addSubview(buttonStackView)
                
                //setting button names
                dismisButton.setTitle(dismissButtonName, for: .normal)
                demandButton.setTitle(demandButtonName, for: .normal)
                
                //adding buttons to the stack view
                buttonStackView.addArrangedSubview(dismisButton)
                buttonStackView.addArrangedSubview(demandButton)
            }
        }
    }
    
    //Init with completion handler
    private func initializeHandlerWithCompletion(alertOption: Bool, constraintOption: Int, completion: () -> ()){
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.alpha = 0
            blackView.frame = window.frame
            windowWidth = window.bounds.size.width
            window.addSubview(blackView)
            window.addSubview(alertView)
            
            //adding views to their corresponding subviews
            alertView.addSubview(headerLabel)
            alertView.addSubview(descriptionTextView)
            
            //completion handler comes here
            completion()
            
            //setting up constratints and alertView's position
            setupConstraints(constraints: constraintOption)
            alertView.frame.origin.x -= windowWidth
        }
    }
    
    //MARK: Settings
    
    private func setupConstraints(constraints: Int){
        //setting up constraints for alertView
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: blackView.centerYAnchor),
            alertView.widthAnchor.constraint(equalTo: blackView.widthAnchor, multiplier: 0.85),
            alertView.heightAnchor.constraint(equalToConstant: 200)
            ])
        
        //setting up constraints for the headerLabel
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 12),
            headerLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -12),
            headerLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
        
        //setting up constraints for the descriptionTextView
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            descriptionTextView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 12),
            descriptionTextView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -12),
            descriptionTextView.bottomAnchor.constraint(equalTo: demandButton.topAnchor, constant: -12)
            ])
        
        if constraints == 1{
            //setting up constraints for the okButton
            NSLayoutConstraint.activate([
                demandButton.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
                demandButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -12),
                demandButton.heightAnchor.constraint(equalToConstant: 30),
                demandButton.widthAnchor.constraint(equalToConstant: 100)
                ])
        } else {
            //setting up constraints for the buttonStackView
            NSLayoutConstraint.activate([
                buttonStackView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
                buttonStackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -12),
                buttonStackView.heightAnchor.constraint(equalToConstant: 30),
                buttonStackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 30)
                ])
        }
    }
    
    //MARK: Actions
    
    @objc private func handleOptions(_ sender: UIButton){
        if alertOption{
            if let controllingVC = controllingViewController as? CustomAlertControllerDelegate {
                controllingVC.handleAlertOptionsForButtons(option: sender.tag)
            }
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.alertView.frame.origin.x += self.windowWidth
            self.alertView.layer.cornerRadius = 100
        }) { (finished) in
            self.alertView.removeFromSuperview()
            self.blackView.removeFromSuperview()
        }
    }
    
    public func show(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.alertView.frame.origin.x = 0
            self.alertView.layer.cornerRadius = 4
            if self.isVibrationEnabled{
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) //vibrating the device here
            }
        }, completion: nil)
    }
    
}

