//
//  changeEmailVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/13/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//  moveToVerifyChangeEmailVC

import UIKit
import Cache
import Firebase


class changeEmailVC: UIViewController {

    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var domain: UILabel!
    
    var email: String!
    var campus: String!
    var testEmailCf: String!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if campus != "", campus != nil {
            
            domain.text = Unidict[campus]
            
            
        } else {
            
            if let campus = try? InformationStorage?.object(ofType: String.self, forKey: "campus") {
                
                domain.text = Unidict[campus!]
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        nickName.becomeFirstResponder()
        
    }

    @IBAction func nextBtnPressed(_ sender: Any) {
        
        if nickName.text != "" {
            
            if let email = nickName.text {
                
                let finalEmail = email + domain.text!
                self.email = finalEmail
                
                swiftLoader()
                
                
                var testEmails = ""
                var  dotCount = [Int]()
                var count = 0
                
                
                
                var testEmailArr = Array(finalEmail)
                for _ in 0..<(testEmailArr.count) {
                    if testEmailArr[count] == "." {
                        
                        dotCount.append(count)
                        
                    }
                    count += 1
                }
                
                
                
                for indexCount in dotCount {
                    testEmailArr[indexCount] = ","
                    let testEmail = String(testEmailArr)
                    testEmails = testEmail
                    testEmailCf = testEmail
                    
                    
                }
                
                
                
                
                DataService.instance.checkEmailUserRef.child(testEmails).observeSingleEvent(of: .value, with: { (snapData) in
                    
                    
                    if snapData.exists() {
                        
                        
                        SwiftLoader.hide()
                        self.showErrorAlert("Oopss !!!", msg: "This email has been used")
                        return
                        
                    } else {
                        
                        Auth.auth().currentUser?.updateEmail(to: finalEmail, completion: { (err) in
                            if err != nil {
                                
                                SwiftLoader.hide()
                                self.showErrorAlert("Oopss !!!", msg: (err?.localizedDescription)!)
                                return
                                
                            }
                            
                            Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
                                if err != nil {
                                    
                                    self.showErrorAlert("Oopss !!!", msg: "Couldn't verify this email")
                                    return
                                    
                                }
                                SwiftLoader.hide()
                                print("Verification email sent")
                                SwiftLoader.hide()
                                self.performSegue(withIdentifier: "moveToVerifyChangeEmailVC", sender: nil)
                            })
                        })
                        
                        
                    }
                        
                    })
                
                
                
                    
                
                    
               
                
                
            }
            
            
        } else {
            
            
            
            self.showErrorAlert("Oopss !!!", msg: "Please enter your email id to continue")
            
        }
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "moveToVerifyEmailVC"{
            if let destination = segue.destination as? verifyChangeEmailVC
            {
                destination.VerifyEmail = self.email
                destination.campus = campus
                destination.testEmail = testEmailCf
            }
        }
        
        
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
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
