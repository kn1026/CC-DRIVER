//
//  RatingVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/4/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase

class RatingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var completedCount: UILabel!
    @IBOutlet weak var totalRateCount: UILabel!
    @IBOutlet weak var five_star_count: UILabel!
    @IBOutlet weak var averateStarCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var cmtArr = [ratingModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        countcompleteRide(mode: "Driver")
        countTotalRate(mode: "Driver")
        countRateFiveStarRate(mode: "Driver")
        loadRateComment(mode: "Driver")
        loadMyRate()
        
    }
    
   

    
    
    
    func loadMyRate() {
        
        
        DataService.instance.mainDataBaseRef.child("Average_Rate").child("Driver").child(userUID).observeSingleEvent(of: .value, with: { (RateData) in
            
            if RateData.exists() {
                
                
                if let dict = RateData.value as? Dictionary<String, Any> {
                    
                    
                    if let RateGet = dict["Rate"] as? Float {
                        

                        self.averateStarCount.text = String(format:"%.1f", RateGet)
                        
                    }
                    
                    
                }
                
                
            } else {
                
                self.averateStarCount.text = ""
                
                
            }
            
            
        })
        
        
    }
    
    
    func countcompleteRide(mode: String) {
        
        DataService.instance.mainDataBaseRef.child("Trip_History").child(mode).child(userUID).observeSingleEvent(of: .value, with: { (completeRide) in
            
            if completeRide.exists() {
                
                let count = completeRide.childrenCount
                
                self.completedCount.text = "\(count)"
                
            } else {
                
                self.totalRateCount.text = "0"
                
                
            }
            
            
            
            
            
        })
        
        
    }
    
    func countTotalRate(mode: String) {
        
        
        DataService.instance.mainDataBaseRef.child("Rating").child(mode).child(userUID).observeSingleEvent(of: .value, with: { (completeRide) in
            
            if completeRide.exists() {
                
                let count = completeRide.childrenCount
                
                self.totalRateCount.text = "\(count - 1)"
                
                
            } else {
                
                self.totalRateCount.text = "0"
                
            }
            
            
            
            
            
        })
        
    }
    
    func loadRateComment(mode: String) {
        
        DataService.instance.mainDataBaseRef.child("Rating").child(mode).child(userUID).queryOrdered(byChild: "TimeStamp").queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { (completeRide) in
            
            if completeRide.exists() {
                
                if let snap = completeRide.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            
                            if item.key != "Five_star" {
                                
                                let ratingResult = ratingModel(postKey: completeRide.key, Rating_model: postDict)
                                
                                
                                self.cmtArr.insert(ratingResult, at: 0)
                                
                                self.tableView.reloadData()
                                
                            }
                            
                            
                            
                            
                            
                        }
                        
                    }
                    
                    
                }
                
                
            } else {
                
                print("Not found")
                
            }
            
            
            
            
            
        })
        
        
    }
    
    func countRateFiveStarRate(mode: String) {
        DataService.instance.mainDataBaseRef.child("Rating").child("Driver").child(userUID).child("Five_star").observeSingleEvent(of: .value, with: { (completeRide) in
            
            if completeRide.exists() {
                
                let count = completeRide.childrenCount
                
                self.five_star_count.text = "\(count)"
                
            } else {
                
                self.five_star_count.text = "0"
                
                
            }
            
            
            
            
            
        })
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cmtArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cmt = cmtArr[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell") as? ratingCell {
            
            if indexPath.row > 0 {
                
                let lineFrame = CGRect(x:20, y:0, width: Double(self.view.frame.width) - 42, height: 1)
                let line = UIView(frame: lineFrame)
                line.backgroundColor = UIColor.groupTableViewBackground
                cell.addSubview(line)
                
                
                
            }
            
            cell.configureCell(cmt)
            
            

            
            
            return cell
            
        } else {
            
            return ratingCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    

    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
