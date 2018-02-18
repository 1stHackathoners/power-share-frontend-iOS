//
//  SigninVC.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit

class SigninVC: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var userNameTextField: UITextField!{
        didSet{
            userNameTextField.placeholder = ENTER_USER_NAME
            userNameTextField.returnKeyType = .continue
            userNameTextField.autocorrectionType = .no
            userNameTextField.autocapitalizationType = .none
            userNameTextField.keyboardType = .alphabet
            userNameTextField.textColor = UIColor.green
            userNameTextField.tintColor = userNameTextField.textColor
            userNameTextField.tag = 1
            userNameTextField.addIcon(image: UIImage(named: PROFILE_ICON), leftPadding: 5)
            userNameTextField.addCharacterCounter(counterLabel: counterLabel, rightPadding: 0)
        }
    }
    @IBOutlet weak var userPasswordTextField: UITextField!{
        didSet{
            userPasswordTextField.placeholder = ENTER_PASSWORD
            userPasswordTextField.isSecureTextEntry = true
            userPasswordTextField.returnKeyType = .continue
            userPasswordTextField.autocorrectionType = .no
            userPasswordTextField.autocapitalizationType = .none
            userPasswordTextField.keyboardType = .alphabet
            userPasswordTextField.textColor = UIColor.green
            userPasswordTextField.tintColor = userPasswordTextField.textColor
            userPasswordTextField.tag = 2
            userPasswordTextField.addIcon(image: UIImage(named: PASSWORD_ICON), leftPadding: 5)
            userPasswordTextField.addCharacterCounter(counterLabel: counterLabel, rightPadding: 0)
        }
    }
    @IBOutlet weak var userReEnteredPasswordTextField: UITextField!{
        didSet{
            userReEnteredPasswordTextField.placeholder = ENTER_PASSWORD
            userReEnteredPasswordTextField.isSecureTextEntry = true
            userReEnteredPasswordTextField.returnKeyType = .go
            userReEnteredPasswordTextField.autocorrectionType = .no
            userReEnteredPasswordTextField.autocapitalizationType = .none
            userReEnteredPasswordTextField.keyboardType = .alphabet
            userReEnteredPasswordTextField.textColor = UIColor.green
            userReEnteredPasswordTextField.tintColor = userReEnteredPasswordTextField.textColor
            userReEnteredPasswordTextField.tag = 3
            userReEnteredPasswordTextField.addIcon(image: UIImage(named: PASSWORD_ICON), leftPadding: 5)
            userReEnteredPasswordTextField.addCharacterCounter(counterLabel: counterLabel, rightPadding: 0)
        }
    }
    @IBOutlet weak var signupButton: UIButton!{
        didSet{
            let attributedString =  NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_REGULAR, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.white])
            signupButton.setAttributedTitle(attributedString, for: .normal)
            signupButton.backgroundColor = UIColor.green
            signupButton.layer.shadowColor = UIColor.lightGray.cgColor
            signupButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            signupButton.layer.shadowOpacity = 1
            signupButton.layer.shadowRadius = 2
            signupButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var alreadyHaveAnAccountButton: UIButton!{
        didSet{
            let attributedString1 = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_REGULAR, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.green])
            
            let attributedString2 = NSMutableAttributedString(string: "Login.", attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.green])
            
            attributedString1.append(attributedString2)
            
            alreadyHaveAnAccountButton.setAttributedTitle(attributedString1, for: .normal)
            alreadyHaveAnAccountButton.backgroundColor = UIColor.clear
            alreadyHaveAnAccountButton.titleLabel?.adjustsFontSizeToFitWidth = true
            alreadyHaveAnAccountButton.titleLabel?.minimumScaleFactor = 10 / UIFont.labelFontSize
        }
    }
    
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        
        // setting delegates
        userNameTextField.delegate = self
        userPasswordTextField.delegate = self
        userReEnteredPasswordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAlphasForFadingINAnimation()
        animateLoginScreen()
        
        // adding observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remove observers
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Animations
    
    private func setAlphasForFadingINAnimation(){
        logoLabel.alpha = 0
        userNameTextField.alpha = 0
        userPasswordTextField.alpha = 0
        userReEnteredPasswordTextField.alpha = 0
        signupButton.alpha = 0
        alreadyHaveAnAccountButton.alpha = 0
    }
    
    private func animateLoginScreen(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.logoLabel.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveLinear, animations: {
            self.userNameTextField.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveLinear, animations: {
            self.userPasswordTextField.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.9, options: .curveLinear, animations: {
            self.userReEnteredPasswordTextField.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1.2, options: .curveLinear, animations: {
            self.signupButton.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveLinear, animations: {
            self.alreadyHaveAnAccountButton.alpha = 1
        }, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        if userNameTextField.text != EMPTY_STRING && userPasswordTextField.text != EMPTY_STRING && userReEnteredPasswordTextField.text != EMPTY_STRING{
            if userPasswordTextField.text == userReEnteredPasswordTextField.text{
                
                // ok create user
            } else {
                alert = CustomAlertController(message: "Upsss", description: "Passwords should match!", buttonTitle: "OK", shouldVibrate: false)
                alert.show()
            }
            
        } else {
            alert = CustomAlertController(message: "Upsss", description: "Fields cannot left blank.", buttonTitle: "OK", shouldVibrate: false)
            alert.show()
        }
    }
    
    @IBAction func alreadyHaveAnAccountButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
