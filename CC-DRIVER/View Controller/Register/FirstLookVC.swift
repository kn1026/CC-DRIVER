//
//  FirstLookVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import FirebaseStorage
import Firebase
import FirebaseAuth
import Cache


class FirstLookVC: UIViewController {
    
    
    
    var name: String?
    var birthday: String?
    var imageUrl: String?
    

   @IBOutlet weak var connectText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view
        
        connectText.textColor = UIColor.yellow
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func LoginWithPhoneNumberBtnPressed(_ sender: Any) {
        
        
        print("moveToPhoneVC")
       
        self.performSegue(withIdentifier: "moveToPhoneVC", sender: nil)
        
    }
    
    
    @IBAction func loginWithRobAccountBtnPressed(_ sender: Any) {
        
        //moveToMapVC3
        
        swiftLoader()
        
        Auth.auth().signIn(withEmail: "cs1058@wildcats.unh.edu", password: dpwd, completion: { (users, error) in
            
            
            if error != nil {
                
                print(error?.localizedDescription as Any)
                self.showErrorAlert("Oops !!!", msg: "Error Occured")
                
                
                SwiftLoader.hide()
                return
            }
            
            //DataService.instance.mainDataBaseRef.child("User").child(userUID)
            
            userUID = (users?.user.uid)!
            
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
                    
                    if let avatarUrl = postDicts["avatarUrl"] as? String {
                        
                        
                        if avatarUrl != "nil" {
                            
                            try? InformationStorage?.setObject(avatarUrl, forKey: "avatarUrl")
                            
                            Alamofire.request(avatarUrl).responseImage { response in
                                
                                if let image = response.result.value {
                                    
                                    
                                    
                                    let wrapper = ImageWrapper(image: image)
                                    try? InformationStorage?.setObject(wrapper, forKey: "avatarImg")
                                    try? InformationStorage?.setObject(avatarUrl, forKey: "avatarUrl")
                                    try? InformationStorage?.setObject(phone, forKey: "phone")
                                    try? InformationStorage?.setObject(stripe_cus, forKey: "stripe_cus")
                                    try? InformationStorage?.setObject(emails, forKey: "email")
                                    try? InformationStorage?.setObject(user_name, forKey: "user_name")
                                    try? InformationStorage?.setObject(birthday, forKey: "birthday")
                                    
                                    
                                    SwiftLoader.hide()
                                    self.performSegue(withIdentifier:
                                        "moveToMapVC3", sender: nil)
                                    
                                }
                                
                                
                            }
                        } else {
                            
                            
                            
                            try? InformationStorage?.setObject(phone, forKey: "phone")
                            try? InformationStorage?.setObject(stripe_cus, forKey: "stripe_cus")
                            try? InformationStorage?.setObject(emails, forKey: "email")
                            try? InformationStorage?.setObject(user_name, forKey: "user_name")
                            try? InformationStorage?.setObject(birthday, forKey: "birthday")
                            
                            
                            SwiftLoader.hide()
                            self.performSegue(withIdentifier:
                                "moveToMapVC3", sender: nil)
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
            })
            
            
            
        })
        

    
}

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        if segue.identifier == "moveToPhoneVC"{
            if let destination = segue.destination as? phoneVC
            {
                destination.imageUrl = self.imageUrl
                destination.birthday = self.birthday
                destination.name = self.name
            }
        }
        
        
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
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    

}
