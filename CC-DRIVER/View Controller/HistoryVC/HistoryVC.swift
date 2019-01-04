//
//  HistoryVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/4/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class HistoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var TripArr = [HistoryModel]()
    
    var time: Any?
    var price: Double?
    var progress: String?
    var last4Digits: String?
    var brandCards: String?
    var pickUpName: String?
    var destinationName: String?
    var carRegistration: String?
    var driverUrlImg: String?
    var carModel: String?
    var name: String?
    var StarLon: CLLocationDegrees?
    var StarLat: CLLocationDegrees?
    var desLon: CLLocationDegrees?
    var desLat: CLLocationDegrees?
    var phone: String?
    var pickUp_name: String?
    var Trip_key: String?
    var rider_uid: String?
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        LoadHistoryRequest(mode: "Driver")
        
        
    }
    
    
    
    func LoadHistoryRequest(mode: String) {
        
        DataService.instance.mainDataBaseRef.child("Trip_History").child(mode).child(userUID).queryOrdered(byChild: "TimeStamp").queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { (TripHistory) in
            
            if TripHistory.exists() {
                
                print("Exists")
                if let snap = TripHistory.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            
                            
                            let TripDataResult = HistoryModel(postKey: TripHistory.key, History_trip_model: postDict)
                            
                            self.TripArr.insert(TripDataResult, at: 0)
                            
                            self.tableView.reloadData()
                            
                            
                            
                        }
                        
                    }
                    
                    
                }
                
                
            } else {
                
                print("No result found")
                
                
            }
            

        })
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if TripArr.isEmpty != true {
            
            tableView.restore()
            return 1
        } else {
            
            tableView.setEmptyMessage("Don't have any trip now !!!")
            return 1
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let trip = TripArr[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryCell {
            
            if indexPath.row != 0 {
                
                let lineFrame = CGRect(x:0, y:-20, width: self.view.frame.width, height: 40)
                let line = UIView(frame: lineFrame)
                line.backgroundColor = UIColor.groupTableViewBackground
                cell.addSubview(line)
                
            }
            
            cell.configureCell(trip)
            
            return cell
            
        } else {
            
            return HistoryCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = TripArr[indexPath.row]
        
        time = item.Timestamp
        price = item.price
        progress = item.Progess
        last4Digits = item.chargedlast4Digit
        brandCards =  item.chargedCardBrand
        pickUpName = item.pickUpName
        destinationName = item.DestinationName
        carRegistration =  item.Car_registration
        //driverUrlImg = item.
        carModel = item.Car_model
        name = item.user_name
        StarLon = item.PickUp_Lon
        StarLat = item.PickUp_Lat
        desLon = item.Destination_Lon
        desLat = item.Destination_Lat
        phone = item.phone
        pickUp_name = item.pickUp_name
        Trip_key = item.Trip_key
        rider_uid = item.rider_UID
        
        self.performSegue(withIdentifier: "MoveToDriverDetailVC", sender: nil)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    

    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "MoveToDriverDetailVC"{
            if let destination = segue.destination as? driverTripDetailVC
            {
                destination.time = time
                destination.price = price
                destination.progress = progress
                destination.last4Digits = chargedlast4Digit
                destination.brandCards =  brandCards
                destination.pickUpName = pickUpName
                destination.destinationName = destinationName
                destination.carRegistration =  carRegistration
                destination.carModel = carModel
                destination.name = name
                destination.StarLon = StarLon
                destination.StarLat = StarLat
                destination.desLon = desLon
                destination.desLat = desLat
                destination.pickUp_name = pickUp_name
                destination.Trip_key = Trip_key
                destination.rider_uid = rider_uid
            }
        }
        
        
    }
   
    
}
