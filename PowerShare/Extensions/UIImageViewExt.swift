//
//  UIImageViewExt.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit

extension UIImageView{
    
    //UIImageView extension to make the frame a circle
    func circleImage(){
        self.layer.cornerRadius = frame.size.height / 2
        self.layer.masksToBounds = true
    }
    
    func borderAndColor(width: CGFloat, color: UIColor){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}

