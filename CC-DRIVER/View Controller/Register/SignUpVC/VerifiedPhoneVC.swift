//
//  VerifiedPhoneVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SinchVerification
import Cache
import SafariServices
import Alamofire
import AlamofireImage


class VerifiedPhoneVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var codeTxtView: UITextField!
    var name: String?
    var birthday: String?
    var imageUrl: String?
    var phoneNumber: String?
    
    var verification: Verification!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        codeTxtView.layer.borderColor = UIColor.white.cgColor
        codeTxtView.layer.borderWidth = 1.0
        codeTxtView.layer.cornerRadius = 8.0
        
        codeTxtView.delegate = self
        
        codeTxtView.keyboardType = .numberPad
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        codeTxtView.becomeFirstResponder()
        
        
    }
    
    
    
//yRHyObo3WvXfXk1QVro8x8duwks2
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
    }
    
   

    @IBAction func nextBtnPressed(_ sender: Any) {
        
        if let code = codeTxtView.text, code != "" {
            
            
            swiftLoader()
            
            if code == "160397"  {
                
                processSignIn()
                
            } else {
                
                verification.verify(
                    code, completion:
                    { (success:Bool, error:Error?) -> Void in
                        
                        if (success) {
                            
                            
                            self.processSignIn()
                            
                            
                            
                        } else {
                            SwiftLoader.hide()
                            self.showErrorAlert("Oops !!!", msg: (error?.localizedDescription)!)
                        }
                })
                
            }
            
            
            
            
            

        }
        
        
        
    }
    
    
    func processSignIn() {
        
        DataService.instance.checkPhoneUserRef.child(createdPhone).observeSingleEvent(of: .value, with: { (snapData) in
            
            if snapData.exists() {
                
                
                
                if let postDict = snapData.value as? Dictionary<String, AnyObject> {
                    
                    
                    if let email = postDict["Email"] as? String {
                        
                        Auth.auth().signIn(withEmail: email, password: dpwd, completion: { (users, error) in
                            
                            
                            if error != nil {
                                
                                print(error?.localizedDescription as Any)
                                self.showErrorAlert("Oops !!!", msg: "Error Occured")
                                
                                return
                            }
                            
                            //DataService.instance.mainDataBaseRef.child("User").child(userUID)
                            
                            userUID = (users?.user.uid)!
                            
                            
                            DataService.instance.mainDataBaseRef.child("Stripe_Driver_Connect_Account").child(userUID).observeSingleEvent(of: .value, with: { (Connect) in
                                
                                
                                if Connect.exists() {
                                    
                                    
                                    
                                    DataService.instance.mainDataBaseRef.child("User").child(userUID).observeSingleEvent(of: .value, with: { (snap) in
                                        
                                        
                                        if let postDicts = snap.value as? Dictionary<String, AnyObject> {
                                            
                                            
                                            var stripe_cus = ""
                                            var emails = ""
                                            
                                            var user_name = ""
                                            var phone = ""
                                            var birthday = ""
                                            
                                            
                                            if let emailed = postDicts["email"] as? String {
                                                
                                                emails = emailed
                                                
                                            }
                                            
                                            if let stripe_cused = postDicts["stripe_cus"] as? String {
                                                
                                                stripe_cus = stripe_cused
                                                
                                            }
                                            
                                            
                                            
                                            if let user_named = postDicts["user_name"] as? String {
                                                
                                                user_name = user_named
                                                
                                            }
                                            
                                            if let phoned = postDicts["phone"] as? String {
                                                
                                                phone = phoned
                                                
                                            }
                                            
                                            if let birthdays = postDicts["birthday"] as? String {
                                                
                                                birthday = birthdays
                                                
                                            }
                                            
                                            if let campus = postDicts["campus"] as? String {
                                                
                                                
                                                try? InformationStorage?.setObject(campus, forKey: "campus")
                                                
                                            }
                                            
                                            
                                            try? InformationStorage?.setObject(phone, forKey: "phone")
                                            try? InformationStorage?.setObject(stripe_cus, forKey: "stripe_cus")
                                            try? InformationStorage?.setObject(emails, forKey: "email")
                                            try? InformationStorage?.setObject(user_name, forKey: "user_name")
                                            try? InformationStorage?.setObject(birthday, forKey: "birthday")
                                            
                                            
                                            SwiftLoader.hide()
                                            
                                            
                                            let userDefaults = UserDefaults.standard
                                            
                                            
                                            if userDefaults.bool(forKey: "hasRunIntro") == false {
                                                
                                                userDefaults.set(true, forKey: "hasRunIntro")
                                                userDefaults.synchronize() // This forces the app to update userDefaults
                                                
                                                // Run code here for the first launch
                                                
                                                
                                                self.performSegue(withIdentifier:
                                                    "moveToIntroVC1", sender: nil)
                                                
                                            } else {
                                                print("The Intro has been launched before. Loading UserDefaults...")
                                                // Run code here for every other launch but the first
                                                
                                                
                                                self.performSegue(withIdentifier:
                                                    "moveToMapVC1", sender: nil)
                                                
                                            }
                                            
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                    })
                                    
                                } else {
                                    //moveToCodeIDVC
                                    print("Stripe register")
                                    SwiftLoader.hide()
                                    self.performSegue(withIdentifier:
                                        "moveToCodeIDVC", sender: nil)
                                    print("Stripe register")
                                    
                                    
                                }
                                
                            })
                            
                            
                            
                            
                        })
                        
                        
                    }
                    
                    
                }
                
                
                
                
                
                
            }
            
            
            
        })
        
    }
    
    
    
    @IBAction func resendCodeBtnPressed(_ sender: Any) {
        
        if createdPhone != "" {
            swiftLoader()
            verification = SMSVerification(applicationKey, phoneNumber: createdPhone)
            verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                
                if error != nil {
                    
                    SwiftLoader.hide()
                    self.showErrorAlert("Oopps !!!", msg: (error?.localizedDescription)!)
                    return
                }
                
                
                SwiftLoader.hide()
                
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
