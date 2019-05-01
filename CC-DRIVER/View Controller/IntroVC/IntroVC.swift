//
//  IntroVC.swift
//  CC-DRIVER
//
//  Created by Khoi Nguyen on 4/30/19.
//  Copyright © 2019 Campus Connect LLC. All rights reserved.
//

import UIKit

class IntroVC: UIViewController {
    
    @IBOutlet weak var view1: circleView!
    @IBOutlet weak var view2: circleView!
    @IBOutlet weak var view3: circleView!
    @IBOutlet weak var view4: circleView!
    
    
    @IBOutlet weak var ImageView: UIImageView!
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ImageView.image = UIImage(named: "01")
        
    }
    
    
    func countCheck() {
        
        
        if count == 1 {
            view1.backgroundColor = UIColor.yellow
            view2.backgroundColor = UIColor.groupTableViewBackground
            view3.backgroundColor = UIColor.groupTableViewBackground
            view4.backgroundColor = UIColor.groupTableViewBackground
            
        } else if count == 2 {
            
            view1.backgroundColor = UIColor.groupTableViewBackground
            view2.backgroundColor = UIColor.yellow
            view3.backgroundColor = UIColor.groupTableViewBackground
            view4.backgroundColor = UIColor.groupTableViewBackground
            
        } else if count == 3 {
            
            view1.backgroundColor = UIColor.groupTableViewBackground
            view2.backgroundColor = UIColor.groupTableViewBackground
            view3.backgroundColor = UIColor.yellow
            view4.backgroundColor = UIColor.groupTableViewBackground
            
        } else if count == 4 {
            
            view1.backgroundColor = UIColor.groupTableViewBackground
            view2.backgroundColor = UIColor.groupTableViewBackground
            view3.backgroundColor = UIColor.groupTableViewBackground
            view4.backgroundColor = UIColor.yellow
            
        }
        
    }
    
    @IBAction func NextBtnPressed(_ sender: Any) {
        
        count += 1
        
        if count > 4 {
            
            let userDefaults = UserDefaults.standard
            
            
            if userDefaults.bool(forKey: "hasRunIntro") == false {
                
                userDefaults.set(true, forKey: "hasRunIntro")
                userDefaults.synchronize() // This forces the app to update userDefaults
                
                // Run code here for the first launch
                
            } else {
                print("The Intro has been launched before. Loading UserDefaults...")
                // Run code here for every other launch but the first
                
            }
            
            
            
            self.performSegue(withIdentifier: "moveToVC123", sender: nil)
            
        } else {
            
            countCheck()
            ImageView.image = UIImage(named: "0\(count)")
            
            
        }
        
        
    }
    
    
    @IBAction func BackBtnPressed(_ sender: Any) {
        
        count -= 1
        
        if count <= 0 {
            
            count += 1
            
        } else {
            
            countCheck()
            ImageView.image = UIImage(named: "0\(count)")
            
            
        }
        
        
        
    }
    
}

