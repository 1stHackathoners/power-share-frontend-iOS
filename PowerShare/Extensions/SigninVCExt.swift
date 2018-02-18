//
//  SigninVCExt.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 18.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit

extension SigninVC: CustomAlertControllerDelegate{

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
            if textField.tag == 1{
                userPasswordTextField.becomeFirstResponder()
            } else {
                userReEnteredPasswordTextField.becomeFirstResponder()
            }
        } else if textField.returnKeyType == .go {
            signupButtonPressed(signupButton)
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
    
    // fetching user data
    
    func postUser(username: String, password: String){
        let url = URL(string: "https://power-share-hackathon.herokuapp.com/user/create")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        
        print(username)
        print(password)
        let postString = "username=\(username)&password=\(password)"
        
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                DispatchQueue.main.async {
                    //showing an alert if something goes wrong
                    let alert = UIAlertController(title: "Upsss!", message: "The load has been added to the completion queue. This will be processed once there is a connection.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                
                
                DispatchQueue.main.async {
                    if let message = json?.value(forKey: "msg") as? String, let statCode = json?.value(forKey: "code") as? Int{
                        print(message)
                        if statCode == 1 {
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }

                    UIView.animate(withDuration: 0.5, animations: {
                        loadingView.alpha = 0
                        refreshIndicator.stopAnimating()
                    })
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func handleAlertOptionsForButtons(option: Int) {
        if option == 1{
            dismiss(animated: true, completion: nil)
        }
    }
    
}

