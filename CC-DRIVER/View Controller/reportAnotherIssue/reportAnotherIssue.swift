//
//  reportAnotherIssue.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/8/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase


class reportAnotherIssue: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var reportTxtField: CommentTxtView!
    var Trip_key: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        reportTxtField.delegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        if reportTxtField.text != "", reportTxtField.text != "Briefly describe your issue" {
            DataService.instance.mainDataBaseRef.child("Report_Trip").child(Trip_key!).child("Driver").childByAutoId().setValue(["Report_UID": userUID, "Timestamp": ServerValue.timestamp(), "Issue": reportTxtField.text, "Trip_key": Trip_key!])
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: false,
                dynamicAnimatorActive: true,
                buttonsLayout: .horizontal
            )
            
            let alert = SCLAlertView(appearance: appearance)
            
            _ = alert.addButton("Got it") {
                
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
            let icon = UIImage(named:"lg1")
            
            _ = alert.showCustom("Thanks !!!", subTitle: "We will review your issue in 24 hours. Thank you for letting us know your issue. ", color: UIColor.black, icon: icon!)
            
            
        } else {
            
            self.showErrorAlert("Oops !!!", msg: "Please provide your problem.")
            
            
        }
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Briefly describe your issue" {
            
            textView.text = ""
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" || textView.text == "Briefly describe your issue" {
            
            textView.text = "Briefly describe your issue"
            
        }
    }
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
}

