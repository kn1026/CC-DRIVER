//
//  driverTripDetailVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/9/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire
import SwiftyJSON
import AlamofireImage
import Cache


class driverTripDetailVC: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var riderNameLbl: UILabel!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var totalPriceLbL: UILabel!
    @IBOutlet weak var moneyRecievedLbl: UILabel!
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var startLocationLbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapView2: GMSMapView!
    
    @IBOutlet weak var riderAvatar: borderAvatarView!
    
    
    
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
    var pickUp_name: String?
    var polyline = GMSPolyline()
    var path = GMSPath()
    var Trip_key: String?
    var rider_uid: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView2.delegate = self
        
        let times = time as? TimeInterval
        let date = Date(timeIntervalSince1970: times!/1000)
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        let timess = timeFormatter.string(from: date)
        
        mapView2.isUserInteractionEnabled = false
        
        if dayDifference(from: date) == "Today" {
            
            timeLbl.text = "Today \(timess)"
            
        } else if dayDifference(from: date) == "Yesterday" {
            
            timeLbl.text = "Yesterday \(timess)"
            
        } else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            let Dateresult = dateFormatter.string(from: date)
            
            
            timeLbl.text = "\(Dateresult) \(timess)"
            
        }
        
        
        progressLbl.text = self.progress!
        progressLbl.text = self.progress!
        
        if progress == "Canceled" {
            
            progressLbl.textColor = UIColor.red
            
        }
        
        loadRiderImg()
        
        totalPriceLbL.text = "$\(String(format:"%.2f", self.price!))"
        startLocationLbl.text = self.pickUpName
        destinationLbl.text  = self.destinationName!
       
        
        let money_receive = String(format:"%.2f", self.price! * 60 / 100)
        moneyRecievedLbl.text = "$\(money_receive)"
    
        let fullNameArr = self.pickUp_name?.components(separatedBy: " ")
        riderNameLbl.text = fullNameArr![0].firstUppercased
        
        
        
        styleMap()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let starLocation = CLLocationCoordinate2D(latitude: StarLat!, longitude: StarLon!)
        let desLocation = CLLocationCoordinate2D(latitude: desLat!, longitude: desLon!)
        
        
        self.drawDirection(pickup: starLocation, destination: desLocation) {
            
            self.fitAllMarkers(_path: self.path)
            
        }
        
        
    }
    
    
    func loadRiderImg() {
        
        
        
        DataService.instance.mainDataBaseRef.child("User").child(rider_uid!).observeSingleEvent(of: .value, with: { (DriverData) in
            
            
            if DriverData.exists() {
                
                
                if let DriverDict = DriverData.value as? Dictionary<String, Any> {
                    
                    if let FaceUrl = DriverDict["avatarUrl"] as? String {
                        
                        if FaceUrl != "nil" {
                            
                            
                            if let CacheRiderImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: FaceUrl).image {
                                
                                self.riderAvatar.image = CacheRiderImg
                                
                            } else {
                                
                                Alamofire.request(FaceUrl).responseImage { response in
                                    
                                    if let image = response.result.value {
                                        
                                        let wrapper = ImageWrapper(image: image)
                                        self.riderAvatar.image = image
                                        try? InformationStorage?.setObject(wrapper, forKey: FaceUrl)
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        } else {
                            
                            
                            let img = UIImage(named: "user")
                            self.riderAvatar.image = img
                            
                        }
                        

                        
                    }
                    
                    
                    
                    
                }
                
                
            } else {
                
                let img = UIImage(named: "user")
                self.riderAvatar.image = img
                
            }
            
            
            
            
        })
        
        
        
        
    }
    
    @IBAction func reportIssueBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToReportTripVC", sender: nil)
        
    }
    
    func styleMap() {
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "customizedMap", withExtension: "json") {
                mapView2.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            
            NSLog("One or more of the map styles failed to load. \(error)")
            
        }
        
        
        
    }
    
    
    func drawDirection(pickup: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completed: @escaping DownloadComplete) {
        
        let origin = "\(pickup.latitude),\(pickup.longitude)"
        let destinations = "\(destination.latitude),\(destination.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destinations)&mode=driving&sensor=true&key=\(googleMap_Key)"
        
        
       // self.polyline.map = nil
        
        
        Alamofire.request(url).responseJSON { response in
            
            let json = try! JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                self.path = GMSPath.init(fromEncodedPath: points!)!
                self.polyline = GMSPolyline.init(path: self.path)
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = UIColor.black
                self.polyline.map = self.mapView2
                
                
                completed()
               
            }
            
            let marker = GMSMarker()
            
            
            marker.position = pickup
            marker.map = self.mapView2
            marker.isTappable = false
            
            let icons = resizeImage(image: UIImage(named: "user")!, targetSize: CGSize(width: 30.0, height: 30.0))
            marker.icon = icons
            
            
            
            
            
            let IconImages = resizeImage(image: UIImage(named: "pin")!, targetSize: CGSize(width: 30.0, height: 30.0))
            let gameMarker = GMSMarker()
            gameMarker.position = destination
            gameMarker.icon = IconImages
            
            gameMarker.map = self.mapView2
            
            
            
        }
        

    }
    
    func fitAllMarkers(_path: GMSPath) {
        var bounds = GMSCoordinateBounds()
        for index in 1..._path.count() {
            bounds = bounds.includingCoordinate(_path.coordinate(at: index))
        }
        mapView2.moveCamera(GMSCameraUpdate.fit(bounds, withPadding: 80))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToReportTripVC"{
            if let destination = segue.destination as? reportAnotherIssue
            {
                
                destination.Trip_key = Trip_key
                
                
            }
            
        }
    }
    
  
    func dayDifference(from date : Date) -> String
    {
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(abs(day)) days ago" }
            else { return "In \(day) days" }
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
