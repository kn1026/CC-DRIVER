//
//  verifyChangePhoneVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/13/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import SinchVerification
import Firebase
import Cache


class verifyChangePhoneVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var codeTxtField: UITextField!
    
    var verification: Verification!
    var phoneNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        codeTxtField.layer.borderColor = UIColor.black.cgColor
        codeTxtField.layer.borderWidth = 1.0
        codeTxtField.layer.cornerRadius = 8.0
        
        codeTxtField.delegate = self
        
        codeTxtField.keyboardType = .numberPad
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        codeTxtField.becomeFirstResponder()
        
    }


    @IBAction func resendCodeBtnPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        if let code = codeTxtField.text, code != "" {
            
            swiftLoader()
            verification.verify(
                code, completion:
                { (success:Bool, error:Error?) -> Void in
                    
                    if (success) {
                        
                        SwiftLoader.hide()
                        
                        
                        
                        if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
                            
                            DataService.instance.mainDataBaseRef.child("Phone").child(self.phoneNumber!).setValue(["Email": email!, "Timestamp": ServerValue.timestamp()])
                            DataService.instance.mainDataBaseRef.child("User").child(userUID).updateChildValues(["Phone": self.phoneNumber!])
                            
                            try? InformationStorage?.removeObject(forKey: "phone")
                            try? InformationStorage?.setObject(self.phoneNumber, forKey: "phone")
                            
                            SwiftLoader.hide()
                            
                            let presentingViewController = self.presentingViewController
                            self.dismiss(animated: false, completion: {
                                presentingViewController?.dismiss(animated: true, completion: {})
                            })
                            
                            
                        } else {
                            
                            
                            SwiftLoader.hide()
                            self.showErrorAlert("Oops !!!", msg: "Unexpected error occurs, please try again")
                            
                        }
                        
                        
                        
                    } else {
                        
                        
                        SwiftLoader.hide()
                        self.showErrorAlert("Oops !!!", msg: (error?.localizedDescription)!)
                        
                        
                    }
            }
            
            
            
        )
            
            
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
    
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
