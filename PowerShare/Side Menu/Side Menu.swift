//
//  Side Menu.swift
//  PowerShare
//
//  Created by Korel Hayrullah on 17.02.2018.
//  Copyright © 2018 PowerShare. All rights reserved.
//

import UIKit

class SideMenu: NSObject{
    
    //MARK: Properties
    var radius: Int = 1
    
    let sideMenu: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let userProfilePicture: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: DEFAULT_PROFILE_IMAGE)
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.green
        image.circleImage()
        image.borderAndColor(width: 1, color: UIColor.green)
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 20)
        label.textColor = UIColor.green
        label.adjustsFontSizeToFitWidth = true
        label.text = "Korel Hayrullah"
        return label
    }()
    
    let mailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: AVENIR_NEXT_ITALIC, size: 15)
        label.textColor = UIColor.green
        label.adjustsFontSizeToFitWidth = true
        label.text = "korel_hayrullah@hotmail.com"
        return label
    }()
    
    
    let totalCreditLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 20)
        label.textColor = UIColor.green
        label.adjustsFontSizeToFitWidth = true
        label.text = "You have $20.00 left."
        return label
    }()
    
    let lookForRadius: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 20)
        label.textColor = UIColor.green
        label.adjustsFontSizeToFitWidth = true
        label.text = "Looking for 1 km radius."
        return label
    }()
    
    lazy var logoutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 20)
        label.textColor = UIColor.green
        label.isUserInteractionEnabled = true
        label.adjustsFontSizeToFitWidth = true
        label.text = "Log out"
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutLabelTapped(_:))))
        return label
    }()
    
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(stepperHasChanged(_:)), for: .valueChanged)
        stepper.minimumValue = 1
        stepper.maximumValue = 5
        stepper.tintColor = UIColor.white
        stepper.backgroundColor = UIColor.green
        return stepper
    }()
    
    let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var sideMenuDraggerOut: UIScreenEdgePanGestureRecognizer = {
        let edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer()
        edgePanGestureRecognizer.edges = .left
        edgePanGestureRecognizer.addTarget(self, action: #selector(dragSideMenuOut(_:)))
        return edgePanGestureRecognizer
    }()
    
    lazy var sideMenuDraggerIn: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(dragSideMenuIn(_:)))
        return panGestureRecognizer
    }()
    
    lazy var dismissSideMenuTapGesture: UITapGestureRecognizer = {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(dismisMenu))
        return tapGestureRecognizer
    }()
    
    let footerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        let attributedString1Shadow = NSShadow()
        attributedString1Shadow.shadowOffset = CGSize(width: -1, height: 1)
        attributedString1Shadow.shadowColor = UIColor(white: 1, alpha: 0.5)
        attributedString1Shadow.shadowBlurRadius = 0.5
        
        let attributedString1 = NSMutableAttributedString(string: FOOTER_NAME, attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.green, NSAttributedStringKey.shadow: attributedString1Shadow])
        
        let attributedString2 = NSMutableAttributedString(string: FOOTER_YEAR, attributes: [NSAttributedStringKey.font: UIFont(name: AVENIR_NEXT_DEMI_BOLD, size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.green])
        
        attributedString1.append(attributedString2)
        
        label.attributedText = attributedString1
        return label
    }()
    
    private var controllingViewController: UIViewController!
    var sideMenuWidthMultiplier: CGFloat = 0.7 // 1 is the whole screen width. Should not be > than 1!
    let blackView = UIView()
    
    //MARK: Methods
    
    init(controllingViewController: UIViewController?) {
        super.init()
        if let window = UIApplication.shared.keyWindow, let controllingVC = controllingViewController{
            //setting the controlling view controller
            self.controllingViewController = controllingVC
            
            //adding dragging gestures to their corresponding views
            self.controllingViewController.view.addGestureRecognizer(sideMenuDraggerOut)
            blackView.addGestureRecognizer(sideMenuDraggerIn)
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(dismissSideMenuTapGesture)
            blackView.frame = window.frame
            blackView.alpha = 0
            window.addSubview(blackView)
            window.addSubview(sideMenu)
            sideMenu.addSubview(userProfilePicture)
            sideMenu.addSubview(nameLabel)
            sideMenu.addSubview(mailLabel)
            sideMenu.addSubview(footerLabel)
            sideMenu.addSubview(optionsStackView)
            optionsStackView.addArrangedSubview(totalCreditLabel)
            optionsStackView.addArrangedSubview(lookForRadius)
            optionsStackView.addArrangedSubview(stepper)
            optionsStackView.addArrangedSubview(logoutLabel)
            setupSideMenuConstraints()
        }
    }
    
    //MARK: Settings
    
    private func setupSideMenuConstraints() {
        NSLayoutConstraint.activate([
            sideMenu.widthAnchor.constraint(equalTo: blackView.widthAnchor, multiplier: sideMenuWidthMultiplier),
            sideMenu.leadingAnchor.constraint(equalTo: blackView.leadingAnchor, constant: -(blackView.frame.width * sideMenuWidthMultiplier)),
            sideMenu.topAnchor.constraint(equalTo: blackView.topAnchor),
            sideMenu.bottomAnchor.constraint(equalTo: blackView.bottomAnchor)
            ])
        NSLayoutConstraint.activate([
            userProfilePicture.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor),
            userProfilePicture.topAnchor.constraint(equalTo: sideMenu.topAnchor, constant: 60),
            userProfilePicture.heightAnchor.constraint(equalToConstant: 128),
            userProfilePicture.widthAnchor.constraint(equalToConstant: 128)
            ])
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: userProfilePicture.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: sideMenu.leadingAnchor, constant: 24),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            mailLabel.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor),
            mailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            mailLabel.leadingAnchor.constraint(equalTo: sideMenu.leadingAnchor, constant: 24),
            mailLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        NSLayoutConstraint.activate([
            optionsStackView.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor),
            optionsStackView.topAnchor.constraint(equalTo: mailLabel.bottomAnchor, constant: 32),
            optionsStackView.leadingAnchor.constraint(equalTo: sideMenu.leadingAnchor, constant: 12),
            optionsStackView.heightAnchor.constraint(equalToConstant: 160)
            ])
        NSLayoutConstraint.activate([
            footerLabel.centerXAnchor.constraint(equalTo: sideMenu.centerXAnchor),
            footerLabel.leadingAnchor.constraint(equalTo: sideMenu.leadingAnchor, constant: 24),
            footerLabel.bottomAnchor.constraint(equalTo: sideMenu.bottomAnchor, constant: -16),
            footerLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    //MARK: Side Menu Dragging Methods
    
    @objc private func dragSideMenuOut(_ gesture: UIScreenEdgePanGestureRecognizer){
        let translation = gesture.translation(in: controllingViewController.view)
        let blackViewFrameWidth = blackView.frame.width * sideMenuWidthMultiplier
        
        if translation.x <= blackViewFrameWidth{
            sideMenu.frame.origin = CGPoint(x: translation.x - blackViewFrameWidth, y: sideMenu.frame.minY)
            blackView.alpha = translation.x / blackViewFrameWidth
            sideMenu.layer.shadowOpacity = Float(blackView.alpha)
            sideMenu.layer.shadowRadius = 2 + blackView.alpha
        } else {
            sideMenu.frame.origin = CGPoint(x: 0, y: sideMenu.frame.minY)
        }
        
        if gesture.state == .ended{
            if translation.x > blackViewFrameWidth * 0.25{
                showMenu()
            } else {
                dismisMenu {
                    return
                }
            }
        }
        
    }
    
    @objc private func dragSideMenuIn(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: sideMenu)
        let blackViewFrameWidth = blackView.frame.width * sideMenuWidthMultiplier
        
        if translation.x > 0{
            sideMenu.frame.origin = CGPoint(x: 0, y: sideMenu.frame.minY)
        } else {
            sideMenu.frame.origin = CGPoint(x: translation.x , y: sideMenu.frame.minY)
            blackView.alpha = 1 - (-translation.x / blackViewFrameWidth)
            sideMenu.layer.shadowOpacity = Float(blackView.alpha)
            sideMenu.layer.shadowRadius = 2 + blackView.alpha
        }
        
        if gesture.state == .ended{
            if translation.x < -blackViewFrameWidth * 0.10 {
                dismisMenu {
                    return
                }
            } else {
                showMenu()
            }
        }
    }
    
    //MARK: Actions
    
    func showMenu(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.sideMenu.layer.shadowOpacity = 1
            self.sideMenu.layer.shadowRadius = 3
            self.sideMenu.frame.origin.x = 0
            self.blackView.alpha = 1
        }, completion: nil)
    }
    
    @objc private func dismisMenu(completion: @escaping () -> () ){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.sideMenu.layer.shadowOpacity = 0
            self.sideMenu.layer.shadowRadius = 0
            self.blackView.alpha = 0
            self.sideMenu.frame.origin.x = -(self.blackView.frame.width * self.sideMenuWidthMultiplier)
        }) { (finisehd) in
            completion()
        }
    }
    
    @objc private func stepperHasChanged(_ sender: UIStepper){
        radius = Int(sender.value)
        lookForRadius.text = "Looking for " + String(sender.value) + " km radius."
        dismisMenu {
            if let controllingVC = self.controllingViewController as? SideMenuDelegate {
                controllingVC.handleSideMenuOptions(selection: 0)
            }
        }
    }
    
    @objc private func logoutLabelTapped(_ gesture: UITapGestureRecognizer){
        dismisMenu {
            if let controllingVC = self.controllingViewController as? SideMenuDelegate {
                controllingVC.handleSideMenuOptions(selection: 1)
            }
        }
    }
}

