//
//  LoginVCExt.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit

extension LoginVC{
    
    //MARK: TextField Handling
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = self.view.frame.size.height - keyboardRectangle.height
            
            if let activeKeyboard = currentylActiveKeyboard{
                if activeKeyboard.frame.origin.y > keyboardHeight - emptySpacePt{
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.frame.origin.y -= (activeKeyboard.frame.origin.y - (keyboardHeight - emptySpacePt))
                    }, completion: nil)
                }
            }
        } else {
            if let activeKeyboard = currentylActiveKeyboard ,let keybHeight = keyboardHeight{
                if activeKeyboard.frame.origin.y > keybHeight - emptySpacePt{
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.frame.origin.y -= (activeKeyboard.frame.origin.y - (keybHeight - emptySpacePt))
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
        textField.becomeFirstResponder()
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
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .continue{
            passwordTextField.becomeFirstResponder()
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
    }

}
