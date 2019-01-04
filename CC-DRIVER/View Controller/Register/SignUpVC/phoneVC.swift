//
//  phoneVerifiedVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SinchVerification


class phoneVC: UIViewController, UITextFieldDelegate {
    
    
    
    var name: String?
    var birthday: String?
    var imageUrl: String?
    var phoneNumber: String?
    
    
    var verification: Verification!
    

    @IBOutlet weak var phoneNumberWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberTxtView: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // phoneNumberWidthConstraint.constant = phoneNumberWidthConstraint.constant * (327/375)
        
        
        if userType == "fb" {
            
            try! Auth.auth().signOut()
            
        }
             
        phoneNumberTxtView.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: phoneNumberTxtView.frame.size.height - width, width:  phoneNumberTxtView.frame.size.width + 50, height: phoneNumberTxtView.frame.size.height)
        
        border.borderWidth = width
        phoneNumberTxtView.layer.addSublayer(border)
        phoneNumberTxtView.layer.masksToBounds = true
        
        phoneNumberTxtView.delegate = self
        
        phoneNumberTxtView.keyboardType = .numberPad
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        phoneNumberTxtView.becomeFirstResponder()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        
        
        if phoneNumberTxtView.text != "" {
            
            self.swiftLoader()
            if let phone = phoneNumberTxtView.text {
                
                
                let finalPhone = "+1\(phone)"
                createdPhone = finalPhone
                
                DataService.instance.checkPhoneUserRef.child(createdPhone).observeSingleEvent(of: .value, with: { (snapData) in
                    
                    if snapData.exists() {
                        
                        if let postDict = snapData.value as? Dictionary<String, AnyObject> {
                            
                            
                            if let email = postDict["Email"] as? String {
                                
                               
                                
                                Auth.auth().signIn(withEmail: email, password: dpwd, completion: { (users, error) in
                                    
                                    
                                    if error != nil {
                                        
                                        
                                        SwiftLoader.hide()
                                        
                                        print(error?.localizedDescription as Any)
                                        self.showErrorAlert("Oops !!!", msg: "Unknown error Occured, code 113")
                                        
                                        return
                                    }
                                    
                                    userUID = (users?.user.uid)!
                                    
                                     DataService.instance.mainDataBaseRef.child("Driver_Info").child(userUID).observeSingleEvent(of: .value, with: { (snapDataDriver) in
                                        
                                        
                                        if snapDataDriver.exists() {
                                            
                                            try? Auth.auth().signOut()
                                            
                                            
                                            self.phoneNumber = finalPhone
                                            
                                            
                                            
                                            
                                            self.verification = SMSVerification(applicationKey, phoneNumber: finalPhone)
                                            
                                            
                                            
                                            self.verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                                                
                                                if error != nil {
                                                    
                                                    SwiftLoader.hide()
                                                    self.showErrorAlert("Oopps !!!", msg: (error?.localizedDescription)!)
                                                    
                                                    return
                                                }
                                                
                                                SwiftLoader.hide()
                                                self.performSegue(withIdentifier: "moveToPhoneVerifiedVC", sender: nil)
                                                
                                                
                                            }
                                            
                                            
                                        } else {
                                            
                                            
                                            SwiftLoader.hide()
                                            
                                            try? Auth.auth().signOut()
                                            
                                            self.showErrorAlert("Oopps !!!", msg: ("Your account is not registered or accepted being a driver yet, please contact our support team for more information."))
                                            
                                            
                                            
                                            return
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                        
                                    })
                                    
                                    
                                })
                                
                                
                            }
                            
                        }
                        
                        
                    } else {
                        
                        SwiftLoader.hide()
                        
                        
                        self.showErrorAlert("Oopps !!!", msg: ("Your account is not registered or accepted being a driver yet, please contact our support team for more information."))
                        return
                        
                        
                    }
                    
                    
                    
                })
                
                
                
                
       
            }
            
            
            
        } else {
            
            
            self.showErrorAlert("Oopps !!!", msg: "Please enter a phone number")
            
            
        }
       
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "moveToPhoneVerifiedVC"{
            if let destination = segue.destination as? VerifiedPhoneVC
            {
                destination.imageUrl = self.imageUrl
                destination.birthday = self.birthday
                destination.name = self.name
                destination.phoneNumber = self.phoneNumber
                destination.verification = verification
            }
        }
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        
        
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "", animated: true)
        
        
        
        
        
        
    }
}
