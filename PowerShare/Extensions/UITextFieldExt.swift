//
//  UITextFieldExt.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit

extension UITextField{
    func addLine(borderWidth: CGFloat){
        //setting the border style to none in order add a single line below the textfield without any borders. Since it would not be nice with other type borders
        self.borderStyle = .none
        
        let border = CALayer()
        
        //the borders color is set to the tint color
        border.borderColor = tintColor.cgColor
        
        border.frame = CGRect(x: 0, y: frame.height - borderWidth, width: UIScreen.main.bounds.width, height: borderWidth)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func addCharacterCounter(counterLabel: UILabel, rightPadding: CGFloat){
        counterLabel.frame = CGRect(x: self.frame.width - rightPadding , y: 0, width: 20, height: 20)
        rightViewMode = .whileEditing
        counterLabel.textColor = UIColor.white
        counterLabel.font = UIFont(name: AVENIR_NEXT_REGULAR, size: 12)!
        rightView = counterLabel
    }
    
    func addIcon(image: UIImage?, leftPadding: CGFloat){
        if let image = image{
            //if there is a image then always show it
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            
            //setting the image to the given image
            imageView.image = image
            
            //setting the image color to the tintcolor (icons are added as template in order do adapt!)
            imageView.tintColor = tintColor
            
            //changing placeholder's color here to its tint color
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : EMPTY_STRING, attributes: [NSAttributedStringKey.foregroundColor: tintColor])
            
            var width = leftPadding + 20
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line{
                width += 5
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
            
            leftView = view
        }
        else{
            //if the image is nill it won't show a image on the left
            leftViewMode = .never
        }
    }
    
    func modifyClearButtonWithImage(image: UIImage?) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(self.clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .unlessEditing
    }
    
    @objc func clear(sender: UIButton) {
        self.text = EMPTY_STRING
    }
}
