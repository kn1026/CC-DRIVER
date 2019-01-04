//
//  codeIDVC.swift
//  CC-DRIVER
//
//  Created by Khoi Nguyen on 9/2/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import SCLAlertView
import SafariServices
import Alamofire
import Firebase


class codeIDVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var codeTxtField: UITextField!
    var alert = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        codeTxtField.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: codeTxtField.frame.size.height - width, width:  codeTxtField.frame.size.width + 50, height: codeTxtField.frame.size.height)
        
        border.borderWidth = width
        codeTxtField.layer.addSublayer(border)
        codeTxtField.layer.masksToBounds = true
        
        codeTxtField.delegate = self
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !alert {
            alertUserCode()
            alert = true
            
        } else {
            print("Showed")
        }
        
        
    }
    
 
    func alertUserCode() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
      
        _ = alert.addButton("Process") {
            

           
            NotificationCenter.default.addObserver(self, selector: #selector(codeIDVC.autoProcessCodeFromDelegate), name: (NSNotification.Name(rawValue: "CodeProcess")), object: nil)
            
            //Progess
            let url = "https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=\(client_id)&scope=read_write"
            
            
            guard let urls = URL(string: url) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(urls)
                
            } else {
                
                UIApplication.shared.openURL(urls)
                
            }
            
            
        }
        
        let icon = UIImage(named:"lg1")
        
        _ = alert.showCustom("Notice !!!", subTitle: "After finished registering with stripe, if it doesn't automatically redirect back and open the app, please copy the whole link and paste it to note and press the link from there. Thank you and sorry for any issue happens. Will be fixed soon!", color: UIColor.black, icon: icon!)
        
        
        
        
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
    
    @objc func autoProcessCodeFromDelegate() {
        
        if authCode != "" {
            NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "CodeProcess")), object: nil)
            self.processCode(authorization_code: authCode)
        }
        
    }
    
    
    func processCode(authorization_code: String) {
        
        if  authorization_code != "" {
            
            swiftLoader()
            
            let url = MainAPIClient.shared.baseURLString
            let urls = URL(string: url!)?.appendingPathComponent("redirect")
            
            Alamofire.request(urls!, method: .post, parameters: [
                
                "authorization_code": authorization_code
                
                ])
                
                .validate(statusCode: 200..<500)
                .responseJSON { responseJSON in
                    
                    switch responseJSON.result {
                        
                    case .success(let json):
                        
                        
                        if let dict = json as? [String: AnyObject] {
                            
                            if let account = dict["stripe_user_id"] as? String {
                                
                                
                                self.createLoginLinks(account: account)
                                
                                
                                
                            }
                            
                            
                        }
                        
                    case .failure( _):
                        
                        
                        SwiftLoader.hide()
                        self.showErrorAlert("Oops !!!", msg: "There are some unknown error during setting up your payout account. Please try again and contact us for more help")
                        
                    }
                    
                    
            }
            
            
        } else {
            
            
            
            self.showErrorAlert("Oops !!!", msg: "Please provide your code")
            
        }
        
        
    }
    
    
 

    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        
        
        
        if let authorization_code = codeTxtField.text, authorization_code != "" {
            
            self.processCode(authorization_code: authorization_code)
            
        }
        
    }
    
    
    func createLoginLinks(account: String){
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("login_links")
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            "account": account
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success(let json):
                    
                    
                    if let dict = json as? [String: AnyObject] {
                        
                        if let url = dict["url"] as? String {
                            
                            DataService.instance.mainDataBaseRef.child("Stripe_Driver_Connect_Account").child(userUID).setValue(["Stripe_Driver_Connect_Account": account,"Login_link": url, "Timestamp": ServerValue.timestamp()])
                             
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
                             self.performSegue(withIdentifier:
                             "moveToMapVC3", sender: nil)
                             
                             
                             }
                             
                             })
                             
   
                            
                            
                        }
                        
                        
                    }
                    
                case .failure( _):
                    
                    
                    SwiftLoader.hide()
                    self.showErrorAlert("Oops !!!", msg: "There are some unknown error during setting up your payout account. Please try again and contact us for more help")
                    
                }
                
                
        }
        
    }
    @IBAction func back1BtnPressed(_ sender: Any) {
        
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
}
