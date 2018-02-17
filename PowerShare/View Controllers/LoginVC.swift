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
            usernameTextField.placeholder = ENTER_USER_NAME
            usernameTextField.returnKeyType = .continue
            usernameTextField.autocorrectionType = .no
            usernameTextField.autocapitalizationType = .none
            usernameTextField.keyboardType = .alphabet
            usernameTextField.textColor = UIColor.green
            usernameTextField.tintColor = usernameTextField.textColor
            usernameTextField.tag = 1
            usernameTextField.addIcon(image: UIImage(named: PROFILE_ICON), leftPadding: 5)
            usernameTextField.addCharacterCounter(counterLabel: counterLabel, rightPadding: 0)
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.placeholder = ENTER_PASSWORD
            passwordTextField.isSecureTextEntry = true
            passwordTextField.returnKeyType = .go
            passwordTextField.autocorrectionType = .no
            passwordTextField.autocapitalizationType = .none
            passwordTextField.keyboardType = .alphabet
            passwordTextField.textColor = UIColor.green
            passwordTextField.tintColor = passwordTextField.textColor
            passwordTextField.tag = 2
            passwordTextField.addIcon(image: UIImage(named: PASSWORD_ICON), leftPadding: 5)
            passwordTextField.addCharacterCounter(counterLabel: counterLabel, rightPadding: 0)
        }
    }
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            let attributedString =  NSMutableAttributedString(string: LOGIN, attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_REGULAR, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.white])
            loginButton.setAttributedTitle(attributedString, for: .normal)
            loginButton.backgroundColor = UIColor.green
            loginButton.layer.shadowColor = UIColor.lightGray.cgColor
            loginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            loginButton.layer.shadowOpacity = 1
            loginButton.layer.shadowRadius = 2
            loginButton.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var signupButton: UIButton!{
        didSet{
            let attributedString1 = NSMutableAttributedString(string: DONT_HAVE_AN_ACCOUNT, attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_REGULAR, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.green])
            
            let attributedString2 = NSMutableAttributedString(string: SIGN_UP, attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.green])
            
            attributedString1.append(attributedString2)
    
            signupButton.setAttributedTitle(attributedString1, for: .normal)
            signupButton.backgroundColor = UIColor.clear
            signupButton.titleLabel?.adjustsFontSizeToFitWidth = true
            signupButton.titleLabel?.minimumScaleFactor = 10 / UIFont.labelFontSize
        }
    }
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remove observers
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAlphasForFadingINAnimation()
        animateLoginScreen()
        
        // adding observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Animations
    
    private func setAlphasForFadingINAnimation(){
        logoLabel.alpha = 0
        usernameTextField.alpha = 0
        passwordTextField.alpha = 0
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
            self.passwordTextField.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.9, options: .curveLinear, animations: {
            self.loginButton.alpha = 1
        }, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        //if any ui elements is active, hide them
        view.endEditing(true)
        
        if usernameTextField.text != EMPTY_STRING && passwordTextField.text != EMPTY_STRING{
            //do some checking and then let the user to get in
            performSegue(withIdentifier: MAIN_MENU_VC_SEGUE, sender: self)
        } else {
            // alert
            alert = CustomAlertController(message: "Upsss!", description: "Fields cannot left blank.", buttonTitle: "OK", shouldVibrate: false)
            alert.show()
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: SIGN_UP_VC_SEGUE, sender: self)
    }
}
