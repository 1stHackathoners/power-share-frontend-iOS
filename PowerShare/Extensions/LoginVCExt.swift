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
    
    // fetching user data
    
    func fetchUser(username: String, completion: @escaping (User, Int) -> ()){
        let url = URL(string: "https://power-share-hackathon.herokuapp.com/user/info")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let postString = "username=\(username)"
        
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
                
                if let json = json{
                    DispatchQueue.main.async {
                        guard let password = json.value(forKey: PASSWORD) as? String else { return }
                        guard let username = json.value(forKey: NAME) as? String else { return }
                        guard let totalCredit = json.value(forKey: TOTAL_CREDIT) as? Int else { return }
                        
                        user = User(username: username, password: password, totalCredit: totalCredit)
                        
                        completion(user!, 1)
                    }
                }
                
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(User(username: EMPTY_STRING, password: EMPTY_STRING, totalCredit: 0), 0)
                }
            }
         
        }
        task.resume()
    }
}
