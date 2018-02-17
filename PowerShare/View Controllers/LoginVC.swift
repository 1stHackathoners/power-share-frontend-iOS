//
//  LoginVC.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    //IBOutlets
    @IBOutlet weak var logoLabel: UILabel!{
        didSet{
            logoLabel.textColor = UIColor.green
            logoLabel.layer.shadowOpacity = 1
            logoLabel.layer.shadowRadius = 0
            logoLabel.layer.shadowOffset = CGSize(width: -2, height: 2)
            logoLabel.layer.shadowColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet{
            usernameTextField.placeholder = "Enter user name"
        }
    }
    @IBOutlet weak var usermailTextField: UITextField!{
        didSet{
            usermailTextField.placeholder = "Enter user mail"
        }
    }
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            let attributedString =  NSMutableAttributedString(string: "Login", attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_REGULAR, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.white])
            loginButton.setAttributedTitle(attributedString, for: .normal)
            loginButton.backgroundColor = UIColor.green
            loginButton.layer.shadowColor = UIColor.lightGray.cgColor
            loginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            loginButton.layer.shadowOpacity = 1
            loginButton.layer.shadowRadius = 2
            loginButton.layer.cornerRadius = 4
        }
    }
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        usermailTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAlphasForFadingINAnimation()
        animateLoginScreen()
    }
    
    //MARK: Animations
    
    private func setAlphasForFadingINAnimation(){
        logoLabel.alpha = 0
        usernameTextField.alpha = 0
        usermailTextField.alpha = 0
        loginButton.alpha = 0
    }
    
    private func animateLoginScreen(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.logoLabel.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveLinear, animations: {
            self.usernameTextField.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveLinear, animations: {
            self.usermailTextField.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.9, options: .curveLinear, animations: {
            self.loginButton.alpha = 1
        }, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //fetch data here and fake authenticate :D
    }
    
    //MARK: TextField Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
