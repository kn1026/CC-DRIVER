//
//  changePhoneVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/13/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//
// moveToVerifyChangePhoneVC
import UIKit
import SinchVerification

class changePhoneVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneTxtField: UITextField!
    
    
    var phoneNumber: String?
    
    
    var verification: Verification!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        phoneTxtField.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: phoneTxtField.frame.size.height - width, width:  phoneTxtField.frame.size.width + 50, height: phoneTxtField.frame.size.height)
        
        border.borderWidth = width
        phoneTxtField.layer.addSublayer(border)
        phoneTxtField.layer.masksToBounds = true
        
        phoneTxtField.delegate = self
        
        phoneTxtField.keyboardType = .numberPad
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        phoneTxtField.becomeFirstResponder()
        
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
    
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        
        if phoneTxtField.text != "" {
            
            self.swiftLoader()
            if let phone = phoneTxtField.text {
                let finalPhone = "+1\(phone)"
                createdPhone = finalPhone
                self.phoneNumber = finalPhone

                self.verification = SMSVerification(applicationKey, phoneNumber: finalPhone)
        
                self.verification.initiate { (result: InitiationResult, error:Error?) -> Void in
                    
                    if error != nil {
                        
                        self.showErrorAlert("Oopps !!!", msg: (error?.localizedDescription)!)
                        return
                    }
                    
                    SwiftLoader.hide()
                   self.performSegue(withIdentifier: "moveToVerifyChangePhoneVC", sender: nil)
     }
                
            }
            
            
            
        } else {
            
            self.showErrorAlert("Oopps !!!", msg: "Please enter a phone number")
            
            
        }
        
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "moveToVerifyChangePhoneVC"{
            if let destination = segue.destination as? verifyChangePhoneVC
            {
                destination.phoneNumber = self.phoneNumber
                destination.verification = verification
            }
        }
        
        
    }
}
