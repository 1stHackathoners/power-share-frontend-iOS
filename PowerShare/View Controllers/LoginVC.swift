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
            usernameTextField.tag = 1
            usermailTextField.returnKeyType = .continue
            usernameTextField.addCharacterCounter(counterLabel: counterLabel, rightPadding: 0)
            
        }
    }
    @IBOutlet weak var usermailTextField: UITextField!{
        didSet{
            usermailTextField.placeholder = "Enter user password"
            usermailTextField.tag = 2
            usermailTextField.isSecureTextEntry = true
            usermailTextField.returnKeyType = .go
            usermailTextField.addCharacterCounter(counterLabel: counterLabel, rightPadding: 0)
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
    
    @IBOutlet weak var signupButton: UIButton!{
        didSet{
            let attributedString1 = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_REGULAR, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.green])
            
            let attributedString2 = NSMutableAttributedString(string: "Sign up now.", attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor.green])
            
            attributedString1.append(attributedString2)
            
            signupButton.setAttributedTitle(attributedString1, for: .normal)
            signupButton.backgroundColor = UIColor.clear
            signupButton.titleLabel?.adjustsFontSizeToFitWidth = true
            signupButton.titleLabel?.minimumScaleFactor = 10 / UIFont.labelFontSize
        }
    }
    
    var currentylActiveKeyboard: UITextField?
    var keyboardHeight: CGFloat!
    let emptySpacePt: CGFloat = 35
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        usermailTextField.delegate = self
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
        
        // add observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        if usernameTextField.text != EMPTY_STRING && usermailTextField.text != EMPTY_STRING{
            //do some checking and then let the user to get in
            performSegue(withIdentifier: MAIN_MENU_VC_SEGUE, sender: self)
        } else {
            alert = CustomAlertController(message: "Upsss!", description: "Fields cannot left blank.", buttonTitle: "OK", shouldVibrate: false)
            alert.show()
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: SIGN_UP_VC_SEGUE, sender: self)
    }
    
    
    //MARK: TextField Handling
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = self.view.frame.size.height - keyboardRectangle.height
            
            if let activeKeyboard = currentylActiveKeyboard{
                if activeKeyboard.frame.origin.y > self.keyboardHeight - self.emptySpacePt{
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.frame.origin.y -= (activeKeyboard.frame.origin.y - (self.keyboardHeight - self.emptySpacePt))
                    }, completion: nil)
                }
            }
        } else {
            if let activeKeyboard = currentylActiveKeyboard ,let keybHeight = keyboardHeight{
                if activeKeyboard.frame.origin.y > keybHeight - emptySpacePt{
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.frame.origin.y -= (activeKeyboard.frame.origin.y - (keybHeight - self.emptySpacePt))
                    }, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.frame.origin.y = 0
                    }, completion: nil)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if view.frame.minY < 0{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.frame.origin.y = 0
            }, completion: nil)
        }
    }
    
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentylActiveKeyboard = nil
        view.endEditing(true)
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        currentylActiveKeyboard = textField
        keyboardWillShow(Notification(name: NSNotification.Name.UIKeyboardWillShow))
        
        if let characterCount = textField.text?.count {
            if textField.tag == 1{
                counterLabel.text = String(40 - characterCount)
            } else {
                counterLabel.text = String(20 - characterCount)
            }
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .continue{
            usermailTextField.becomeFirstResponder()
        } else if textField.returnKeyType == .go {
            loginButtonPressed(loginButton)
        }
        textField.resignFirstResponder()
        currentylActiveKeyboard = nil
        return true
    }
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if textField.tag == 1{
            counterLabel.text = newString.count == 41 ? String(0) : String(40 - newString.count)
            return newString.count <= 40
        } else {
            counterLabel.text = newString.count == 21 ? String(0) : String(20 - newString.count)
            return newString.count <= 20
        }
    }}
