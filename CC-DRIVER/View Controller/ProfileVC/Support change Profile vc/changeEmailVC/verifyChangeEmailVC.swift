//
//  verifyChangeEmailVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/13/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase
import Cache
import Alamofire

class verifyChangeEmailVC: UIViewController {

    
    var VerifyEmail: String?
    var campus: String?
    var testEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        
        
        reUpdatedOriginalEmail()
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        reUpdatedOriginalEmail()
    }
    
    func reUpdatedOriginalEmail() {
    
    
         if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
            
            
            Auth.auth().currentUser?.updateEmail(to: email!, completion: { (err) in
                
                if err != nil {
                    
                    print("Unexpected error occurs, please try again")
                    
                }
                
            })
            
            
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
    
    
    }
    
    @IBAction func resendEmailBtnPressed(_ sender: Any) {
        
        
        Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
            if err != nil {

                self.showErrorAlert("Oops !!!", msg: "Cannot send the email, please try again")
                
                
                
            } else {
                
                self.showErrorAlert("Successfully", msg: "Please check your inbox to verify your email")
                
            }
        })
        
    }
    
    func updateEmailForStripeUser(completed: @escaping DownloadComplete) {
        
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("customers_email_update")
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            
                "email": VerifyEmail!,
                "cus_id": stripeID
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success( _):
                    
                    completed()
           
                case .failure( _):
                    SwiftLoader.hide()
                    self.showErrorAlert("Oops !!!", msg: "This email couldn't be used for some reason or due to technical issue, please contact us for more detail")
                    
                }
                
                
                
        }
        
        
        
    }
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        
        Auth.auth().currentUser?.reload(completion: { (err) in
            if err == nil{
                
                userUID = (Auth.auth().currentUser?.uid)!
                if Auth.auth().currentUser?.isEmailVerified != true {
                    
                    self.showErrorAlert("Oops !!!", msg: "The email hasn't verified, please check your inbox or resend the email")
                    
                } else {
                    
                    self.swiftLoader()
     
                    self.updateEmailForStripeUser {
                        
                        if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
                            
                            
                            
                            if let phone = try? InformationStorage?.object(ofType: String.self, forKey: "phone") {
                                
                                
                                self.swiftLoader()
                                
                                let finalEmail = email!
                                
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
                                }
                                DataService.instance.mainDataBaseRef.child("User").child(userUID).updateChildValues(["Email": self.VerifyEmail!])
                                DataService.instance.mainDataBaseRef.child("Email").child(testEmails).removeValue()
                                DataService.instance.mainDataBaseRef.child("Email").child(self.testEmail!).setValue(["Timestamp": ServerValue.timestamp()])
                                DataService.instance.mainDataBaseRef.child("Phone").child(phone!).updateChildValues(["Email": self.VerifyEmail!])
                                
                                try? InformationStorage?.removeObject(forKey: "email")
                                try? InformationStorage?.setObject(self.VerifyEmail, forKey: "email")
                                
                                if self.campus != nil, self.campus != "" {
                                    
                                    
                                    DataService.instance.mainDataBaseRef.child("User").child(userUID).updateChildValues(["campus": self.campus!])
                                    try? InformationStorage?.removeObject(forKey: "campus")
                                    try? InformationStorage?.setObject(self.campus, forKey: "campus")
                                    
                                    
                                }
                                
                                
                                
                                let presentingViewController = self.presentingViewController
                                self.dismiss(animated: false, completion: {
                                    presentingViewController?.dismiss(animated: true, completion: {})
                                })
                                
                            }
                            
                            
                        }
                        
                    }
     
                }
                
            } else {
                
                self.showErrorAlert("Oops !!!", msg: "Unexpected error occurs, please try again")
                
            }
        })
        
        
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
