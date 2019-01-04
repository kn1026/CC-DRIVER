

//
//  reportLostItem.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/8/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import SCLAlertView


class reportLostItem: UIViewController, UITextViewDelegate {

    @IBOutlet weak var IssueMessageLbl: CommentTxtView!
    var phone: String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        IssueMessageLbl.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if IssueMessageLbl.text == "Briefly describe your lost item" {
            
            IssueMessageLbl.text = ""
            
            
        }
        
        
        
    }
    

    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func SubmitBtnPressed(_ sender: Any) {
        
        if IssueMessageLbl.text != "", IssueMessageLbl.text != "Briefly describe your lost item" {
            
            
            self.view.endEditing(true)
            IssueMessageLbl.text = "Briefly describe your lost item"
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: false,
                dynamicAnimatorActive: true,
                buttonsLayout: .horizontal
            )
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("Cancel") {
                
            }
            _ = alert.addButton("Call driver") {
                
                
                
                self.makeAPhoneCall()
                
            }
            
            let icon = UIImage(named:"lg1")
 
            _ = alert.showCustom("Thanks for letting us know!", subTitle: "The fastest way to find your item is to call your driver immediately! Would you like to call your driver?", color: UIColor.black, icon: icon!)
            
        } else {
            
            
        }
        
    }
    
    func makeAPhoneCall()  {
        
        if let callId = phone {
          
            if let url = URL(string: "tel://\(callId)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                print("Cannot Call")
                
            }

            
        }
        
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        
        self.view.endEditing(true)
        
    }
    
}
