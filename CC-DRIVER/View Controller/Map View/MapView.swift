//
//  MapView.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//



import UIKit
import Foundation
import GoogleMaps
import GooglePlaces
import Firebase
import MapKit
import Pulsator
import Alamofire
import SwiftyJSON
import Cache
import SafariServices
import GeoFire
import Stripe
import UserNotifications
import KDCircularProgress
import AVFoundation
import PassKit
import SCLAlertView
import JDropDownAlert
import ZendriveSDK
import FirebaseAuth



class MapView: UIViewController, GMSMapViewDelegate, UITextViewDelegate, UNUserNotificationCenterDelegate, ZendriveDelegateProtocol {
    
    
    @IBOutlet weak var rateProfile: UILabel!
    
    
    @IBOutlet weak var riderRateCount: UILabel!
    
    var handelCancelFromRider: UInt?
 
    var rateCount = 0
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingTitle: UILabel!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var ratingText: CommentTxtView!
    var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var mainNameLbl: UILabel!
    
    var signalResponse = 0
   
    var rate_rider_uid: String?
    var DriverEta: String?
    var TripRiderResult: Rider_trip_model!
    var tripDriverReuslt: Driver_trip_model!
    var trip_key: String?
    var trip_key_created = ""
    var navigationCoordinate: CLLocationCoordinate2D!
    
    
    var IsSendMess = false
    var IsDeliverMess = false
    
    
    @IBOutlet weak var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var pickUpView: UIView!
    @IBOutlet weak var arriveBtn: UIButton!
    
    @IBOutlet weak var progressMode: UILabel!
    @IBOutlet weak var riderName: UILabel!
    @IBOutlet weak var progressAddress: UILabel!
    
    
    @IBOutlet weak var topDirectionView: UIView!
    
    @IBOutlet weak var bottomDirectionView: UIView!
    
    
    var avatarIcon: UIImage!
    
    
    
    @IBOutlet weak var RiderRequestAvatarImg: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    var toDestination = false
    var driverLocation = CLLocationCoordinate2D()
    var driverMarker = GMSMarker()
    var isAccepted = false
    var progress: KDCircularProgress!
    @IBOutlet weak var progressView: UIView!
    var current_request_trip_key = ""
    var current_request_trip_uid = ""
    @IBOutlet weak var acceptRideView: UIView!
    
    @IBOutlet weak var riderRequestName: UILabel!
    
    @IBOutlet weak var riderRequestStarLbl: UILabel!
    
    @IBOutlet weak var riderPriceRequestLbl: UILabel!
    
    @IBOutlet weak var riderRequestDistanceLbl: UILabel!
    
    @IBOutlet weak var riderRequestDestinationLbl: UILabel!
    
    @IBOutlet weak var riderRequestPickUpLocLbl: UILabel!
    
   
    var authorize = false
    var capturedKey = ""
    var isDriver = false
    
    var Rider_handle: UInt?
    var Driver_handle: UInt?
    var rider_trip_coordinator_handle: UInt?
    var completed_trip_handle: UInt?
    
    
    
    
    @IBOutlet weak var switchBtn: UISwitchCustom!
    var isConnected = false
    
   
    
    @IBOutlet weak var alertLbl: UILabel!
    var listCampus = [String]()
    var listDriver = [String]()
    var listRecentDriver = [String]()
    var currentCount = 0
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var driveHistory: UIButton!
    
    @IBOutlet weak var drivePayment: UIButton!
    @IBOutlet weak var driveAboutus: UIButton!
    @IBOutlet weak var driveReport: UIButton!
    @IBOutlet weak var driveHelp: UIButton!
    @IBOutlet weak var driveSignOut: UIButton!
    var eta = ""
    
    @IBOutlet weak var pickUpBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
   
    @IBOutlet weak var TotalDriverView: UIView!
    
    @IBOutlet weak var blurView: UIView!
    
   
    
    @IBOutlet weak var mapViewBottomConstraint: NSLayoutConstraint!
    
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    
    
    var placesClient = GMSPlacesClient()
    var panHandle = false
    @IBOutlet weak var closeProfileBtn2: UIButton!
    @IBOutlet weak var animated2Btn: UIButton!
   
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var closeProfileBtn: UIButton!
    @IBOutlet weak var animatedBtn: UIButton!
    
    
    
    var isFirst = false
    
    // drag View
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var avatarView: UIView!
    
    private var dragViewAnimatedTopMargin:CGFloat = 0.0 // View fully visible (upper spacing)
    private var viewDefaultHeight:CGFloat = 50.0// View height when appear
    private var gestureRecognizer = UIPanGestureRecognizer()
    private var dragViewDefaultTopMargin:CGFloat!
    private var viewLastYPosition = 0.0
    
    
    
    @IBOutlet weak var menuView: UIView!
    var marker = GMSMarker()
    var circle = GMSCircle()
    
    
    let pulsator = Pulsator()
    
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var localLocation: CLLocation!
    
    
    var visibleRegion = GMSVisibleRegion()
    var bounds = GMSCoordinateBounds()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        guard Auth.auth().currentUser != nil else {
            
           
            
            return
            
        }
        
        switchBtn.isOn = false
        
        
        if (try? InformationStorage?.object(ofType: String.self, forKey: "phone")) == nil{
            
            return
            
        }
        
        if let emails = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
            
            if emails != Auth.auth().currentUser?.email {
                
                Auth.auth().currentUser?.updateEmail(to: emails!, completion: { (err) in
                    
                    if err != nil {
                        
                        
                        self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
                        
                    }
                    
                    return
                    
                })
                
                
            }
            
            
        }
        
        
        tapGesture = UITapGestureRecognizer(target: self, action:#selector(MapView.closeKeyboard))
        
        LocalNotification.registerForLocalNotification(on: UIApplication.shared)
        
        
        // profile
        
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - viewDefaultHeight
        
        mapView.delegate = self
        
        userType = ""
        
        // Do any additional setup after loading the view.
        
        
        locationManager.delegate = self
        
        
        styleMap()
        configureLocationServices()
        check_server_maintenance()
        //setupDefaultMap()
        
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.menuView.addGestureRecognizer(gestureRecognizer)
        
        userUID = (Auth.auth().currentUser?.uid)!
        
        
        checkIfAccountRemove()
        // align btn text
        setAlignmentForBnt()
        checkConnection()
        setupZenDrive()
        
        
        
        pulsator.radius = 25
        pulsator.backgroundColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 1).cgColor
        
        
        self.menuView.translatesAutoresizingMaskIntoConstraints = true
        
        userUID = (Auth.auth().currentUser?.uid)!
        
        if let cus_id = try? InformationStorage?.object(ofType: String.self, forKey: "stripe_cus") {
            
            if cus_id != "nil" {
                
                
                stripeID = cus_id!
                
                self.retrieveDefaultCard(cus_id: cus_id!)
                
            }
            
        }
        
        setupProgress()
        self.checkIfDriverIsInProgress()
        self.notiWhenTip()
        
        
        
        Messaging.messaging().subscribe(toTopic: "CC-Driver") { error in
            if error == nil {
                
                print("Subscribed to CC-Drvier topic")
                
            }
            
        }
        
        

        
        if let campus = try? InformationStorage?.object(ofType: String.self, forKey: "campus") {
            
            if let cc = campus {
                
                DataService.instance.mainDataBaseRef.child("Available_Campus").child(cc).observeSingleEvent(of: .value, with: { (schoolData) in
                    
                    
                    if schoolData.exists() {
                        
                        if let dict = schoolData.value as? Dictionary<String, Any> {
                            
                            
                            if let subKey = dict["Key"] as? String {
                                
                                Messaging.messaging().subscribe(toTopic: "\(subKey)") { error in
                                    
                                    if let err = error {
                                        print("Error subscribe: \(err.localizedDescription)")
                                        return
                                    }
                                    
                                    print("Subscribed to \(subKey) topic")
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                })
                

                
            }
            
        } else {
            
            print("Can't load campus")
            
        }
        
        
    }
    
    
    
    
    @objc func closeKeyboard() {
        
        self.view.removeGestureRecognizer(tapGesture)
        
        self.view.endEditing(true)
        
    }
    
    func checkIfAccountRemove() {
        
        DataService.instance.mainDataBaseRef.child("Driver_Info").child(userUID).observe( .value, with: { (maintenance) in
            
            if maintenance.exists() {
                
                
            } else {
                
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
                    
                    try! Auth.auth().signOut()
                    try? InformationStorage?.removeAll()
                    DataService.instance.mainDataBaseRef.removeAllObservers()
                    self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
                    
                    
                }
                
                let icon = UIImage(named:"lg1")
                
                _ = alert.showCustom("Sorry !!!", subTitle: "Your account has been removed for some reasons, please contact us for more information through support@campusconnectonline.com ", color: UIColor.black, icon: icon!)
                
            }
            
            
        })
    }
    
    
    func checkIfDriverIsInProgress() {
        
        DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(userUID).observeSingleEvent(of: .value, with: { (Data) in
            
            
            if Data.exists() {
                
                
                
                
                
                if let dict = Data.value as? Dictionary<String, Any> {
                    
                    if let key = dict["Trip_key"] as? String {
                        
                        if let Rider_UID = dict["Rider_UID"] as? String {
                            
                            
                            DataService.instance.mainDataBaseRef.child("Trip_request").child(Rider_UID).child(key).observeSingleEvent(of: .value, with: { (TripData) in
                                
                                
                                if TripData.exists() {
                                    
                                    if let tripDict = TripData.value as? Dictionary<String, AnyObject> {
                                        
                                        
                                        
                                        self.temporaryTerminateAcceptingRide()
                                        
                                        let TripDataResult = Rider_trip_model(postKey: TripData.key, Rider_trip_model: tripDict)
                                        
                                        self.TripRiderResult = TripDataResult
                                        
                                        
                                        self.current_request_trip_key = TripDataResult.Trip_key
                                        self.current_request_trip_uid = TripDataResult.rider_UID
                                        
                                        
                                        
                                        self.isAccepted = true
                                        self.IsSendMess = false
                                        self.IsDeliverMess = false
                                        
                                        self.progress.stopAnimation()
                                        Zendrive.startDrive(self.current_request_trip_key)
                                        self.locationManager.startUpdatingLocation()
                                        DataService.instance.mainDataBaseRef.child("Rider_Observe_Trip").child(self.current_request_trip_uid).child(self.current_request_trip_key).child("Status").setValue(userUID)
                                        
                                        self.observeCancelFromRider(key: self.current_request_trip_key)
                                        
                                        
                                        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                                            
                                            
                                            // self.acceptRideView.frame = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: self.acceptRideView.frame.width, height: self.acceptRideView.frame.height)
                                            
                                            
                                            
                                        }), completion:  { (finished: Bool) in
                                            
                                            self.blurView.isHidden = true
                                            self.acceptRideView.isHidden = true
                                            
                                            
                                            DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Rider").child(self.TripRiderResult.rider_UID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.TripRiderResult.Trip_key, "Driver_UID": userUID, "Rider_UID": self.TripRiderResult.rider_UID])
                                            DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(userUID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.TripRiderResult.Trip_key, "Driver_UID": userUID, "Rider_UID": self.TripRiderResult.rider_UID])
                                            
                                            
                                            self.updateDriveTripUI() {
                                                
                                                
                                                let Mylocation =  CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                                                let destination = CLLocationCoordinate2D(latitude: self.TripRiderResult.PickUp_Lat, longitude: self.TripRiderResult.PickUp_Lon)
                                                self.navigationCoordinate = CLLocationCoordinate2D(latitude: self.TripRiderResult.PickUp_Lat, longitude: self.TripRiderResult.PickUp_Lon)
                                                
                                                
                                                self.pulsator.stop()
                                                
                                                self.get_rider_avatar(uid: self.TripRiderResult.rider_UID) {
                                                    
                                                    self.drawRouteForDriver(myLocation: Mylocation, destinationed: destination, imageName: "user"){
                                                        
                                                        
                                                        self.pulsator.start()
                                                        self.fitAllMarkers(_path: self.path)
                                                        
                                                    }
                                                    
                                                }
                                                
                                                
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                            
                                            
                                            
                                        })
                                        
                                        
                                    }
                                    
                                }
                                
                            })
                            
                            
                            
                        }
                        
                    }
                    
                    
                }
                    
                
                
                
            } else {
                
                
               
        DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Driver").child(userUID).observeSingleEvent(of: .value, with: { (arrived) in
                    
                    
                    
                    if arrived.exists() {
                        
                        
                        if let dict = arrived.value as? Dictionary<String, Any> {
                            
                            
                            if let key = dict["Trip_key"] as? String {
                                
                                if let Rider_UID = dict["Rider_UID"] as? String {
                                    
                                    DataService.instance.mainDataBaseRef.child("Trip_request").child(Rider_UID).child(key).observeSingleEvent(of: .value, with: { (TripData) in
                                        
                                        
                                        if TripData.exists() {
                                            
                                            if let tripDict = TripData.value as? Dictionary<String, AnyObject> {
                                                
                                                
                                                let TripDataResult = Rider_trip_model(postKey: TripData.key, Rider_trip_model: tripDict)
                                                
                                                self.TripRiderResult = TripDataResult
                                                
                                                pickUpLocation = CLLocationCoordinate2D(latitude: self.TripRiderResult.PickUp_Lat, longitude: self.TripRiderResult.PickUp_Lon)
                                                DestinationLocation = CLLocationCoordinate2D(latitude: self.TripRiderResult.Destination_Lat, longitude: self.TripRiderResult.Destination_Lon)
                                                
                                                // 1. update ui driver
                                                // 2. update observe for rider and driver
                                                // 3. redraw map
                                                
                                                
                                                self.updateDriveTripUI() {
                                                    
                                                    self.UpdateUIAfterPickedUp()
                                                    let Mylocation =  CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                                                    let destination = CLLocationCoordinate2D(latitude: self.TripRiderResult.Destination_Lat, longitude: self.TripRiderResult.Destination_Lon)
                                                    
                                                    
                                                    DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(self.TripRiderResult.rider_UID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Pick up", "Timestamp": ServerValue.timestamp()])
                                                    
                                                    DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(userUID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Pick up", "Timestamp": ServerValue.timestamp()])
                                                    
                                                    
                                                    DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Rider").child(self.TripRiderResult.rider_UID).removeValue()
                                                    DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(userUID).removeValue()
                                                    DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Rider").child(self.TripRiderResult.rider_UID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.TripRiderResult.Trip_key, "Driver_UID": userUID, "Rider_UID": self.TripRiderResult.rider_UID])
                                                    
                                                    DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Driver").child(userUID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.TripRiderResult.Trip_key, "Driver_UID": userUID, "Rider_UID": self.TripRiderResult.rider_UID])
                                                    
                                                    
                                                    DataService.instance.mainDataBaseRef.child("Cancel_request").child(userUID).removeAllObservers()
                                                    
                                                    
                                                    self.pulsator.stop()
                                                    self.drawRouteForDriver(myLocation: Mylocation, destinationed: destination, imageName: "pin"){
                                                        
                                                        
                                                        self.pulsator.start()
                                                        self.fitAllMarkers(_path: self.path)
                                                        self.UpdateObserveForRider()
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                                
                                                
                                                
                                                
                                               
                                            }
                                            
                                        }
                                        
                                    })
                                    
                                    
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                })
                
            }
            
            
            
        })
        
        
        
    }

    
    func loadMyRate() {
        
        
        DataService.instance.mainDataBaseRef.child("Average_Rate").child("Driver").child(userUID).observeSingleEvent(of: .value, with: { (RateData) in
            
            if RateData.exists() {
                
                
                if let dict = RateData.value as? Dictionary<String, Any> {
                    
                    
                    if let RateGet = dict["Rate"] as? Float {
                        
                        
                        
                        self.rateProfile.text = String(format:"%.1f", RateGet)
                        
                    }
                    
                    
                }
                
                
            } else {
                
                self.rateProfile.text = ""
                
                
            }
            
            
        })
        
        
    }
    
    func setupZenDrive() {
        
        let configuration = ZendriveConfiguration()
        configuration.applicationKey = driveSDKKeyString
        let driveDetectionMode = ZendriveDriveDetectionMode.autoON
        
        configuration.driverId = userUID
        configuration.driveDetectionMode = driveDetectionMode
        let driverAttrs = ZendriveDriverAttributes()
        
        if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
            
            if let phone = try? InformationStorage?.object(ofType: String.self, forKey: "phone")  {
            
            let fullNameArr = name?.components(separatedBy: " ")
            let firstName = fullNameArr![0].firstUppercased
            let lastName = fullNameArr![(fullNameArr?.count)! - 1].firstUppercased
            
            
            driverAttrs.setFirstName(firstName)
            driverAttrs.setLastName(lastName)
            driverAttrs.setPhoneNumber(phone!)
                
                
                
            let serviceLevel = ZendriveServiceLevel.level1
            driverAttrs.setServiceLevel(serviceLevel)
            configuration.driverAttributes = driverAttrs
                
            Zendrive.setup(with: configuration, delegate: self) { (success, err) in
                    if (success) {
                        
                        print("Done")
                        
                    } else {
                        
                        
                        self.showErrorAlertSignOut("Ops !!!", msg: "Error loading your account, contact support for more information")
                        
                        
                        
                    }
                }
                
        
            }
            
            
        }
        
        
        
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        
        
        guard Auth.auth().currentUser != nil else {
            
            self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
            return
        }
        
        
        if (try? InformationStorage?.object(ofType: String.self, forKey: "phone")) == nil{
            
            self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
            return
            
            
        }
        
        
        
        let userDefaults = UserDefaults.standard
        
        
        if userDefaults.bool(forKey: "hasRunIntro") == false {
            
            userDefaults.set(true, forKey: "hasRunIntro")
            userDefaults.synchronize() // This forces the app to update userDefaults
            
            // Run code here for the first launch
            
            
            self.performSegue(withIdentifier:
                "moveToIntroVC2", sender: nil)
            
            return
            
        } else {
            print("The Intro has been launched before. Loading UserDefaults...")
            // Run code here for every other launch but the first
            
            
            
        }
        
        
        
        
        
//        moveToIntroVC2
        
        if marker.iconView != nil  {
            
            pulsator.start()
            
        }
        
        if isFirst == false {
            
            self.menuView.layer.cornerRadius = 60.0
            self.menuView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 50.0, width:  UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            
            isFirst = true
        }
        
        
        if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
            
            mainNameLbl.text = name
       
        }
        
        if let CacheavatarImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: "avatarImg").image {
            
            userImageView.isHidden = false
            userImageView.image = CacheavatarImg
            
        }
        
        checkIfRiderRateForRide()
        loadMyRate()
        
        if notiCalled == true {
            self.single_ObserveTrip()
            notiCalled = false
        }
        
        
        check_if_driver_on_pending()
        
        
    }
    
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        pulsator.stop()
        
    }
    
   
    
    func updateUIForRating() {
        
        rateCount = 0
        self.blurView.isHidden = false
        self.ratingView.isHidden = false
        star1.setImage(UIImage(named: "starnofill"), for: .normal)
        star2.setImage(UIImage(named: "starnofill"), for: .normal)
        star3.setImage(UIImage(named: "starnofill"), for: .normal)
        star4.setImage(UIImage(named: "starnofill"), for: .normal)
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        self.ratingText.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            
            
            
            self.ratingView.frame = CGRect(x: (UIScreen.main.bounds.width - 288) / 2, y: (UIScreen.main.bounds.height - 280) / 2, width: self.ratingView.frame.width, height: self.ratingView.frame.height)
            
            
            
            
            
        }), completion:  { (finished: Bool) in
            
            
            self.ratingTitle.text = "How was your passenger?"
            
            
            
        })
        
        
        
    }
    
    
    @IBAction func star1BtnPressed(_ sender: Any) {
        
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        
        
        // unstar
        
        
        star2.setImage(UIImage(named: "starnofill"), for: .normal)
        star3.setImage(UIImage(named: "starnofill"), for: .normal)
        star4.setImage(UIImage(named: "starnofill"), for: .normal)
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        
        
        rateCount = 1
    }
    
    
    @IBAction func star2BtnPressed(_ sender: Any) {
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        star2.setImage(UIImage(named: "star"), for: .normal)
        
        // unstar
        
        
        
        star3.setImage(UIImage(named: "starnofill"), for: .normal)
        star4.setImage(UIImage(named: "starnofill"), for: .normal)
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        
        
        rateCount = 2
    }
    
    @IBAction func star3BtnPressed(_ sender: Any) {
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        star2.setImage(UIImage(named: "star"), for: .normal)
        star3.setImage(UIImage(named: "star"), for: .normal)
        // unstar
        
        
        
        star4.setImage(UIImage(named: "starnofill"), for: .normal)
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        
        
        rateCount = 3
        
    }
    
    @IBAction func star4BtnPressed(_ sender: Any) {
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        star2.setImage(UIImage(named: "star"), for: .normal)
        star3.setImage(UIImage(named: "star"), for: .normal)
        star4.setImage(UIImage(named: "star"), for: .normal)
        // unstar
        
        
        
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        
        
        rateCount = 4
        
    }
    
    @IBAction func star5BtnPressed(_ sender: Any) {
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        star2.setImage(UIImage(named: "star"), for: .normal)
        star3.setImage(UIImage(named: "star"), for: .normal)
        star4.setImage(UIImage(named: "star"), for: .normal)
        star5.setImage(UIImage(named: "star"), for: .normal)
        
        
        rateCount = 5
        
    }
   
    
    
    func checkConnection() {
        
        DataService.instance.connectedRef.observe(.value, with: { snapShot in
            if let connected = snapShot.value as? Bool, connected {
                
                self.alertView.isHidden = true
                self.isConnected = true
                
                
            } else {
                
                
                
                
                self.alertView.backgroundColor = UIColor.red
                self.alertLbl.text = "No connection"
                self.alertLbl.textColor = UIColor.white
                self.alertView.isHidden = false
                
                self.isConnected = false
                
            }
            
        })
        
    }
    
    
    func retrieveDefaultCard(cus_id: String) {
        
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("default_card")
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            "cus_id": cus_id
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success(let json):
                    
                    if let dict = json as? [String: AnyObject] {
                        
                        if let defaults = dict["default_source"] as? String {
                            
                            defaultCardID = defaults
                            chargedCardID = defaultCardID
                            
                        }
                        
                        
                        if let sources = dict["sources"] as? Dictionary<String, AnyObject> {
                            
                            if let cardArr = sources["data"] as? [Dictionary<String, AnyObject>] {
                                
                                
                                if cardArr.isEmpty != true {
                                    
                                    
                                    if let last4 = cardArr[0]["last4"] as? String {
                                        
                                        defaultcardLast4Digits = last4
                                        chargedlast4Digit = defaultcardLast4Digits
                                        
                                        
                                    }
                                    
                                    if let brand = cardArr[0]["brand"] as? String {
                                        
                                        defaultBrand = brand
                                        chargedCardBrand = defaultBrand
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                case .failure(let error):
                    print(error)
                    
                }
                
                
                
        }
        
        
    }
    
   
    
   
    
    
    
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.activityType = .automotiveNavigation
        manager.allowsBackgroundLocationUpdates = true
        
        if let coor =  locations.last?.coordinate {
            
            if toDestination != true {
                
                if isAccepted != false {
                    
                    
                    UpdateService.instance.updateOnTripDriverLocation(withCoordinate: coor, key: self.TripRiderResult.Trip_key)
                    
                    let des = CLLocation(latitude: TripRiderResult.PickUp_Lat, longitude: TripRiderResult.PickUp_Lon)
                    let coors = locations.last
                    
                    let distance = calculateDistanceBetweenTwoCoordinator(baseLocation: coors!, destinationLocation: des)
                    
                    self.marker.position = coor
                    self.marker.tracksViewChanges = true
                    self.marker.map = self.mapView
                    
                    
                    if distance < 1.0 {
                        
                        //self.pickUpBtn.isHidden = false
                        
                        
                        if self.IsSendMess == false || self.IsDeliverMess == false {
                            
                            
                            signalResponse = 0
                            
                            checkRiderSignalOnTrip(riderUID: TripRiderResult.rider_UID, key: TripRiderResult.Trip_key)
                            
                            
                            
                            delay(3) {
                                
                                
                                DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(self.TripRiderResult.Trip_key).child(self.TripRiderResult.rider_UID).child("Response").removeAllObservers()
                                
                                if self.IsSendMess == false {
                                    
                                    if self.signalResponse == 0 {
                                        
                                        
                                        
                                        let sms = "You driver is about \(round(distance * 100) / 100) miles away, please prepare soon"
                                        self.sendSmsNoti(Phone: self.TripRiderResult.PickUp_Phone, text: sms)
                                        
                                        
                                    } else {
                                        
                                        // rider loaders local noti
                                        
                                    }
                                    
                                    
                                    self.IsSendMess = true
                                    
                                } else {
                                    
                                    if distance < 0.2 {
                                        
                                        if self.IsDeliverMess == false {
                                            
                                            if self.signalResponse == 0 {
                                                
                                                let sms = "You driver is here !!!"
                                                self.sendSmsNoti(Phone: self.TripRiderResult.PickUp_Phone, text: sms)
                                                
                                            } else {
                                                
                                                
                                                // rider loads local noti
                                            }
                                            
                                            
                                            self.IsDeliverMess = true
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                } else {
                    
                    
                    UpdateService.instance.updateDriverLocation(withCoordinate: coor)
                    
                }
            } else {
                
                
                self.marker.position = coor
                self.marker.tracksViewChanges = true
                self.marker.map = self.mapView
                
                
               
                
            }
            
            
            
            
        }
        
        
        
        
    }
    
    func calculateDistanceBetweenTwoCoordinator(baseLocation: CLLocation, destinationLocation: CLLocation) -> Double {
        
        let coordinate₀ = baseLocation
        let coordinate₁ = destinationLocation
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        
        let distanceInMiles = Double(distanceInMeters) * 0.000621371192
        
        return distanceInMiles
        
    }
    
    func fitAllMarkers(_path: GMSPath) {
        var bounds = GMSCoordinateBounds()
        for index in 1..._path.count() {
            bounds = bounds.includingCoordinate(_path.coordinate(at: index))
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 140.0))
        
    }
    
    
    func returnLocation(coor: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        return coor
        
    }
    
    func setAlignmentForBnt() {
        
       
        
        driveHistory.contentHorizontalAlignment = .left
        
        drivePayment.contentHorizontalAlignment = .left
        driveAboutus.contentHorizontalAlignment = .left
        driveReport.contentHorizontalAlignment = .left
        driveHelp.contentHorizontalAlignment = .left
        driveSignOut.contentHorizontalAlignment = .left
        
    }

    
   
    
    
    
    func centerMapDuringTrip() {
        
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        let cordinated = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 13)
        self.marker.position = cordinated
        self.marker.map = mapView
        self.mapView.camera = camera
        self.mapView.animate(to: camera)
        self.fitAllMarkers(_path: path)
    }
    
    
    
    
    
    func centerMapOnUserLocation() {
        
        self.mapView.clear()
        self.locationManager.stopUpdatingLocation()
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        
        
        localLocation = CLLocation(latitude: coordinate.latitude, longitude:coordinate.longitude)
        
        let cordinated = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        // get MapView
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 13)
        
        
        self.marker.iconView = nil
        
        
        //mapV
        
        
        self.marker.position = cordinated
        self.marker.map = mapView
        
        
        self.mapView.camera = camera
        self.mapView.animate(to: camera)
        
        
        self.marker.isTappable = false
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        myView.backgroundColor = UIColor.clear
        self.marker.iconView = myView
        
        visibleRegion = mapView.projection.visibleRegion()
        bounds = GMSCoordinateBounds(coordinate: visibleRegion.nearLeft, coordinate: visibleRegion.farRight)
        
        
        pulsator.position =  (marker.iconView!.center)
        self.marker.iconView?.layer.addSublayer(pulsator)
        self.marker.iconView?.backgroundColor = UIColor.clear
        
        
        
        
        myView.backgroundColor = UIColor.clear
        let IconImage = resizeImage(image: UIImage(named: "my")!, targetSize: CGSize(width: 20.0, height: 20.0))
        let markerView = UIImageView(image: IconImage)
        markerView.center = myView.center
        
        self.marker.appearAnimation = .pop
        myView.addSubview(markerView)
        
        
        pulsator.start()
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "openSearchVC"{
            if let destination = segue.destination as? searchController
            {
                destination.bounds = self.bounds
                
            }
        }
        
        
    }
    
    
    func configureLocationService() {
        
        
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            centerMapOnUserLocation()
            
        }
        
        
    }
    
    func styleMap() {
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "customizedMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        
        
    }
    @IBAction func closeBtn2Pressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            self.menuView.frame = CGRect(x: 0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.menuView.frame.size.height)
            self.menuView.layer.cornerRadius = 60.0
            self.animatedBtn.isHidden = false
            self.animated2Btn.isHidden = false
            self.userImgView.isHidden = true
            self.closeProfileBtn.isHidden = true
            self.closeProfileBtn2.isHidden = true
            
        }), completion: nil)
        
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            self.menuView.frame = CGRect(x: 0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.menuView.frame.size.height)
            self.menuView.layer.cornerRadius = 60.0
            self.animatedBtn.isHidden = false
            self.animated2Btn.isHidden = false
            self.userImgView.isHidden = true
            self.closeProfileBtn.isHidden = true
            self.closeProfileBtn2.isHidden = true
            
        }), completion: nil)
        
    }
    @IBAction func animatedProfileViewBtn2Pressed(_ sender: Any) {
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            self.menuView.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.menuView.frame.size.height)
            self.menuView.layer.cornerRadius = 0.0
            self.animatedBtn.isHidden = true
            self.animated2Btn.isHidden = true
            self.closeProfileBtn.isHidden = false
            self.userImgView.isHidden = false
            self.closeProfileBtn2.isHidden = false
            let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
            self.scrollView.setContentOffset(desiredOffset, animated: true)
            
        }), completion: nil)
        
        
    }
    
    @IBAction func animateProfileViewBtnPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            self.menuView.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.menuView.frame.size.height)
            self.menuView.layer.cornerRadius = 0.0
            self.animatedBtn.isHidden = true
            self.animated2Btn.isHidden = true
            self.closeProfileBtn.isHidden = false
            self.userImgView.isHidden = false
            self.closeProfileBtn2.isHidden = false
            let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
            self.scrollView.setContentOffset(desiredOffset, animated: true)
            
        }), completion: nil)
        
        
    }
    
    @IBAction func centerMyLocationBtnPressed(_ sender: Any) {
        
        
        if topDirectionView.isHidden == false {
            
            
            centerMapDuringTrip()
            
            
        } else {
            
            pulsator.stop()
            centerMapOnUserLocation()
            
        }
        
        
    }
    // handle drag view
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            
            var newTranslation = CGPoint()
            var oldTranslation = CGPoint()
            newTranslation = gestureRecognizer.translation(in: self.view)
            
            if(!(newTranslation.y < 0 && self.menuView.frame.origin.y + newTranslation.y <= dragViewAnimatedTopMargin))
            {
                self.menuView.translatesAutoresizingMaskIntoConstraints = true
                self.menuView.center = CGPoint(x: self.menuView.center.x, y: self.menuView.center.y + newTranslation.y)
                
                if (newTranslation.y < 0)
                {
                    
                    
                    if("\(self.menuView.frame.size.width)" != "\(String(describing: self.view.frame.size.width))")
                    {
                        if self.menuView.frame.size.width >= (self.view.frame.size.width)
                        {
                            self.menuView.frame = CGRect(x: self.menuView.frame.origin.x, y:self.menuView.frame.origin.y , width: self.menuView.frame.size.width, height: self.menuView.frame.size.height)
                            
                            
                        }
                        else{
                            self.menuView.frame = CGRect(x: self.menuView.frame.origin.x - 2, y:self.menuView.frame.origin.y , width: self.menuView.frame.size.width + 4, height: self.menuView.frame.size.height)
                            
                            
                        }
                        
                    }
                }
                else
                {
                    
                    if("\(self.menuView.frame.size.width)" != "\((self.view.frame.size.width) - 20)")
                    {
                        self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: self.menuView.frame.size.width , height: self.menuView.frame.size.height)
                    }
                }
                
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
                
                oldTranslation.y = newTranslation.y
            }
            else
            {
                self.menuView.frame.origin.y = dragViewAnimatedTopMargin
                self.menuView.isUserInteractionEnabled = false
            }
            
        }
        else if (gestureRecognizer.state == .ended)
        {
            
            
            self.menuView.isUserInteractionEnabled = true
            let vel = gestureRecognizer.velocity(in: self.view)
            
            
            let finalY: CGFloat = 50.0
            let curY: CGFloat = self.menuView.frame.origin.y
            let distance: CGFloat = curY - finalY
            
            
            let springVelocity: CGFloat = 1.0 * vel.y / distance
            
            
            if(springVelocity > 0 && self.menuView.frame.origin.y <= dragViewAnimatedTopMargin)
            {
                self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                
            }
            else if (springVelocity > 0)
            {
                
                if (self.menuView.frame.origin.y < (self.view.frame.size.height)/3 && springVelocity < 7)
                {
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                        if("\(self.menuView.frame.size.width)" != "\(String(describing: self.view.frame.size.width))")
                        {
                            self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                            
                            self.menuView.layer.cornerRadius = 0.0
                            self.animatedBtn.isHidden = true
                            self.animated2Btn.isHidden = true
                            self.closeProfileBtn.isHidden = false
                            self.closeProfileBtn2.isHidden = false
                            self.userImgView.isHidden = false
                            let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
                            self.scrollView.setContentOffset(desiredOffset, animated: true)
                        }
                        
                        self.menuView.frame.origin.y = self.dragViewAnimatedTopMargin
                    }), completion:  { (finished: Bool) in
                        
                        
                        
                        
                    })
                }
                else
                {
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                        
                        if(self.menuView.frame.size.width != (self.view.frame.size.width) - 20)
                        {
                            self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                            
                            self.menuView.layer.cornerRadius = 60.0
                            self.animatedBtn.isHidden = false
                            self.animated2Btn.isHidden = false
                            self.closeProfileBtn.isHidden = true
                            self.userImgView.isHidden = true
                            self.closeProfileBtn2.isHidden = true
                            
                        }
                        
                        self.menuView.frame.origin.y = self.dragViewDefaultTopMargin
                        
                        
                    }), completion:  { (finished: Bool) in
                        
                        
                        
                        
                        
                    })
                }
            }
            else if (springVelocity == 0)// If Velocity zero remain at same position
            {
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    self.menuView.frame.origin.y = CGFloat(self.viewLastYPosition)
                    
                    if(self.menuView.frame.origin.y == self.dragViewDefaultTopMargin)
                    {
                        if("\(self.menuView.frame.size.width)" == "\(String(describing: self.view.frame.size.width))")
                        {
                            self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: self.menuView.frame.size.width, height: self.menuView.frame.size.height)
                            
                            self.menuView.layer.cornerRadius = 60.0
                            self.animatedBtn.isHidden = false
                            self.animated2Btn.isHidden = false
                            self.closeProfileBtn.isHidden = true
                            self.userImgView.isHidden = true
                            self.closeProfileBtn2.isHidden = true
                        }
                    }
                    else{
                        if("\(self.menuView.frame.size.width)" != "\(String(describing: self.view.frame.size.width))")
                        {
                            self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                            self.menuView.layer.cornerRadius = 0.0
                            self.animatedBtn.isHidden = true
                            self.animated2Btn.isHidden = true
                            self.closeProfileBtn.isHidden = false
                            self.closeProfileBtn2.isHidden = false
                            self.userImgView.isHidden = false
                            let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
                            self.scrollView.setContentOffset(desiredOffset, animated: true)
                            
                            
                            
                        }
                    }
                    
                }), completion:  { (finished: Bool) in
                    
                    
                    
                    
                })
            }
            else
            {
                if("\(self.menuView.frame.size.width)" != "\(String(describing: self.view.frame.size.width))")
                {
                    self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                    
                }
                
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    self.menuView.frame.origin.y = self.dragViewAnimatedTopMargin
                    self.menuView.layer.cornerRadius = 0.0
                    self.animatedBtn.isHidden = true
                    self.animated2Btn.isHidden = true
                    self.closeProfileBtn.isHidden = false
                    self.closeProfileBtn2.isHidden = false
                    self.userImgView.isHidden = false
                    let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
                    self.scrollView.setContentOffset(desiredOffset, animated: true)
                    
                }), completion:  { (finished: Bool) in
                    
                    
                    
                    
                })
                
                
                
                
            }
            viewLastYPosition = Double(self.menuView.frame.origin.y)
            
            self.menuView.addGestureRecognizer(gestureRecognizer)
        }
        
    }
    @IBAction func reportBtnPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "moveToReportVC", sender: nil)
        
    }
    
   
    
    
    func check_if_driver_on_pending() {
        
        
        DataService.instance.mainDataBaseRef.child("Driver_coordinator").child(userUID).observeSingleEvent(of: .value, with: { (DriverCoor ) in
            
            if DriverCoor.exists() {
                
                self.alertView.isHidden = false
                self.switchBtn.isOn = true
                self.alertView.backgroundColor = UIColor.yellow
                self.alertLbl.text = "Finding Rides…"
                self.alertLbl.textColor = UIColor.darkGray
                
                DataService.instance.mainDataBaseRef.child("Pending_driver").child(userUID).removeValue()
                
                self.locationManager.startUpdatingLocation()
                
                
                DispatchQueue.global(qos: .background).async {
                    print("Run on background thread")
                    self.Driver_observeTrip()
                }
                
                
            } else {
                
                self.alertView.isHidden = true
                self.switchBtn.isOn = false
                
                self.locationManager.stopUpdatingLocation()
                
                DataService.instance.mainDataBaseRef.child("Driver_coordinator").child(userUID).removeValue()
                
                
                
            }
            
            
        })
        
        
        
    }
    
   
    
   
    
    func observeCurrentDriverCoordinate(UID: String,key: String, completed: @escaping DownloadComplete) {
        
        DataService.instance.mainDataBaseRef.child("On_Trip_Driver_coordinator").child(UID).child(key).observeSingleEvent(of: .value, with: { (DriverCoor ) in
            
            if let coor = DriverCoor.value as? Dictionary<String, Any> {
                
                let location = CLLocationCoordinate2D(latitude: coor["Lat"] as! CLLocationDegrees, longitude: coor["Lon"] as! CLLocationDegrees)
                
                self.driverLocation = location
                
                completed()
                
            }
            
        })
        
    }
    
    
    
    func observeMovingDriverCoordinate(UID: String, key: String) {
        
        rider_trip_coordinator_handle = DataService.instance.mainDataBaseRef.child("On_Trip_Driver_coordinator").child(UID).child(key).observe(.value, with: { (DriverCoor ) in
            
            if let coor = DriverCoor.value as? Dictionary<String, Any> {
                
                let location = CLLocationCoordinate2D(latitude: coor["Lat"] as! CLLocationDegrees, longitude: coor["Lon"] as! CLLocationDegrees)
                self.driverMarker.position = location
                self.driverMarker.tracksViewChanges = true
                self.driverMarker.map = self.mapView
                
                
                
                
                
            }
            
        })
        
    }
    
    
    func single_ObserveTrip() {
        
        
        DataService.instance.mainDataBaseRef.child("Pending_driver").child(userUID).observeSingleEvent(of: .value, with: { (tripData) in
            
            if tripData.exists() {
                
                if let snap = tripData.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            if let riderUID = postDict["UID"] as? String {
                                
                                if let trip_key = postDict["key"] as? String {
                                    
                                    self.get_trip(rider_uid: riderUID, trip_key: trip_key)
                                    
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
                
                
                
                
            }
            
            
            
        })
        
        
    }

    
    func Driver_observeTrip() {
        
        
        
        Driver_handle = DataService.instance.mainDataBaseRef.child("Pending_driver").child(userUID).observe(.value, with: { (tripData) in
            
            if tripData.exists() {
                
                DataService.instance.mainDataBaseRef.child("Pending_driver").child(userUID).removeObserver(withHandle: self.Driver_handle!)
                
                
                if let snap = tripData.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            if let riderUID = postDict["UID"] as? String {
                                
                                if let trip_key = postDict["key"] as? String {
                                    
                                    self.get_trip(rider_uid: riderUID, trip_key: trip_key)
                                    
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
                
                
                
                
            }
            
            
            
        })
        
        
    }
    
    
    func get_trip(rider_uid: String, trip_key: String) {
        
        DataService.instance.mainDataBaseRef.child("Trip_request").child(rider_uid).child(trip_key).observeSingleEvent(of: .value, with: { (TripData) in
            
            
            if TripData.exists() {
                
                
                
                
                if let tripDict = TripData.value as? Dictionary<String, AnyObject> {
                    
                    
                    // temporary not updating coordinate
                    // show trip
                    
                    
                    
                    self.temporaryTerminateAcceptingRide()
                    
                    let TripDataResult = Rider_trip_model(postKey: TripData.key, Rider_trip_model: tripDict)
                    
                    self.TripRiderResult = TripDataResult
                    
                    
                    self.current_request_trip_key = TripDataResult.Trip_key
                    self.current_request_trip_uid = TripDataResult.rider_UID
                    
                    
                    // to play sound
                    let systemSoundID: SystemSoundID = 1023
                    AudioServicesPlaySystemSound(systemSoundID)
                    
                    
                    self.assignTrip(TripDataResult: TripDataResult)
                    
                    if UIApplication.shared.applicationState == .active {
                        
                        
                       LocalNotification.dispatchlocalNotification(with: "You just received a ride request!", body: "Check it out now before it expires in 20 seconds.")
                        
                        
                    } else {
                        
                        LocalNotification.dispatchlocalNotification(with: "You just received a ride request!", body: "Check it out now before it expires in 20 seconds.")
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
        })
        
    }
    
    func check_server_maintenance() {
        
        
        DataService.instance.mainDataBaseRef.child("server_maintenance").observe( .value, with: { (maintenance) in
            
            if maintenance.exists() {
                
                self.temporaryTerminateAcceptingRide()
                
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
                    
                    try! Auth.auth().signOut()
                    try? InformationStorage?.removeAll()
                    DataService.instance.mainDataBaseRef.removeAllObservers()
                    self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
                    
                    
                }
                
                let icon = UIImage(named:"lg1")
                
                _ = alert.showCustom("Sorry !!!", subTitle: "The app is under maintenance. Please comeback later ", color: UIColor.black, icon: icon!)
                
                
            }
            
            
        })
        
        
    }
    
    func loadRate(uid: String) {
        
        DataService.instance.mainDataBaseRef.child("Average_Rate").child("Rider").child(uid).observeSingleEvent(of: .value, with: { (RateData) in
            
            if RateData.exists() {
                
                
                if let dict = RateData.value as? Dictionary<String, Any> {
                    
                    
                    if let RateGet = dict["Rate"] as? Float {
                        
                        
                        self.riderRequestStarLbl.text = String(format:"%.1f", RateGet)
                        
                        
                    }
                    
                    
                }
                
                
            } else {
                
                self.riderRequestStarLbl.text = ""
                
                
            }
            
            
        })
        
    }
    
    
    func assignTrip(TripDataResult: Rider_trip_model) {
        
        
        DataService.instance.mainDataBaseRef.child("Fail_check").child(TripDataResult.rider_UID).child(TripDataResult.capturedKey).observeSingleEvent(of: .value, with: { (Fail) in
            
            if Fail.exists() {
                
                
                self.switchBtn.isOn = false
                self.cancelTripRequest()
                
            } else {
                
                
                self.isAccepted = false
                
                self.riderRequestName.text = TripDataResult.pickUp_name
                
                
                self.loadRate(uid: TripDataResult.rider_UID)
                self.riderPriceRequestLbl.text = "$\(String(TripDataResult.price))"
                self.riderRequestDistanceLbl.text = "\(TripDataResult.distance!)mi"
                self.riderRequestDestinationLbl.text = TripDataResult.destinationAddress
                self.riderRequestPickUpLocLbl.text = TripDataResult.pickUpAddress
                self.blurView.isHidden = false
                
                self.acceptRideView.isHidden = false
                
                
                
                DataService.instance.mainDataBaseRef.child("Average_Rate").child("Rider").child(TripDataResult.rider_UID).observeSingleEvent(of: .value, with: { (RateData) in
                    
                    if RateData.exists() {
                        
                        
                        if let dict = RateData.value as? Dictionary<String, Any> {
                            
                            
                            if let RateGet = dict["Rate"] as? Float {
                                
                                
                                
                                self.riderRateCount.text = String(format:"%.1f", RateGet)
                                
                            }
                            
                            
                        }
                        
                        
                    } else {
                        
                        self.riderRateCount.text = ""
                        
                        
                    }
                    
                    
                })
                
                
                self.progress.startAngle = -90
                self.progress.animate(fromAngle: 0, toAngle: 360, duration: 15) { completed in
                    
                    
                    
                    if completed {
                        
                        if self.isAccepted != true {
                            
                            self.switchBtn.isOn = false
                            self.cancelTripRequest()
                            
                        }
                        
                        
                    } else {
                        
                        
                        
                        print("animation stopped, was interrupted")
                    }
                    
                }
                
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    
                    
                    
                    self.acceptRideView.frame = CGRect(x: (UIScreen.main.bounds.width - 300) / 2, y: (UIScreen.main.bounds.height - 350) / 2, width: self.acceptRideView.frame.width, height: self.acceptRideView.frame.height)
                    
                    
                    
                    
                    
                }), completion:  nil)
                
                
                
            }
            
        })
        
        
        

        
        
    }
    
    
    @IBAction func cancelRequestTripBtnPressed(_ sender: Any) {
        
        
        cancelTripRequest()
        
        
        
    }
    
    
    func cancelTripRequest() {
        
        DataService.instance.mainDataBaseRef.child("Rider_Observe_Trip").child(current_request_trip_uid).child(current_request_trip_key).child("Status").setValue(0)
        
        
            progress.stopAnimation()
        
        
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            
            
            
                self.acceptRideView.frame = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: self.acceptRideView.frame.width, height: self.acceptRideView.frame.height)
            
            
            
        }), completion:  { (finished: Bool) in
            
            self.blurView.isHidden = true
            self.acceptRideView.isHidden = true
            self.enableAcceptingRide()
        })
        
    }
    
    
    @IBAction func acceptRequestTripBtnPressed(_ sender: Any) {
        
        
        isAccepted = true
        IsSendMess = false
        IsDeliverMess = false
        toDestination = false
        
        progress.stopAnimation()
        Zendrive.startDrive(current_request_trip_key)
        self.locationManager.startUpdatingLocation()
        DataService.instance.mainDataBaseRef.child("Rider_Observe_Trip").child(current_request_trip_uid).child(current_request_trip_key).child("Status").setValue(userUID)
        
        self.observeCancelFromRider(key: current_request_trip_key)
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            
            self.acceptRideView.frame = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: self.acceptRideView.frame.width, height: self.acceptRideView.frame.height)
            
            
            
        }), completion:  { (finished: Bool) in
            
            self.blurView.isHidden = true
            self.acceptRideView.isHidden = true
       
            
        DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Rider").child(self.TripRiderResult.rider_UID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.TripRiderResult.Trip_key, "Driver_UID": userUID, "Rider_UID": self.TripRiderResult.rider_UID])
        DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(userUID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.TripRiderResult.Trip_key, "Driver_UID": userUID, "Rider_UID": self.TripRiderResult.rider_UID])
            
            self.updateDriveTripUI() {
                
                
                let Mylocation =  CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                let destination = CLLocationCoordinate2D(latitude: self.TripRiderResult.PickUp_Lat, longitude: self.TripRiderResult.PickUp_Lon)
                self.navigationCoordinate = CLLocationCoordinate2D(latitude: self.TripRiderResult.PickUp_Lat, longitude: self.TripRiderResult.PickUp_Lon)
                
                
                self.pulsator.stop()
                
                
                self.get_rider_avatar(uid: self.TripRiderResult.rider_UID) {
                    
                    self.drawRouteForDriver(myLocation: Mylocation, destinationed: destination, imageName: "user"){
                        
                        
                        self.pulsator.start()
                        self.fitAllMarkers(_path: self.path)
                        
                    }
                    
                }

                
                
                
            }
            
        })
        
        
        
        
        
        
        
        
        
        
    }
    
    func get_rider_avatar(uid: String, completed: @escaping DownloadComplete) {
        
        avatarIcon = nil
        
        DataService.instance.mainDataBaseRef.child("User").child(uid).observeSingleEvent(of: .value, with: { (data) in
            
            if data.exists() {
                
                if let dict = data.value as? Dictionary<String, Any> {
                    
                    
                    if let avatar = dict["avatarUrl"] as? String {
                        
                        
                        if avatar == "nil" {
                            
                            
                            completed()
                            
                        } else {
                            
                            
                            if let CachedriderImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: avatar).image {
                                
                                
                                self.avatarIcon = CachedriderImg
                                
                                completed()
                                
                                
                            } else {
                                
                                Alamofire.request(avatar).responseImage { response in
                                    
                                    if let image = response.result.value {
                                        
                                        let wrapper = ImageWrapper(image: image)
                                        self.avatarIcon = image
                                        try? InformationStorage?.setObject(wrapper, forKey: avatar)
                                        
                                        completed()
                                        
                                    }
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
            } else {
                
                completed()
                
            }
            
            
            
            
            
        })
        
        
        
    }
    
    func updateDriveTripUI(completed: @escaping DownloadComplete) {
        
        
        
        cancelView.isHidden = false
        pickUpView.isHidden = false
        pickUpBtn.isHidden = false
        arriveBtn.isHidden = true
        
        topDirectionView.isHidden = false
        bottomDirectionView.isHidden = false
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            
            self.mapViewBottomConstraint.constant = 110
            self.mapViewTopConstraint.constant = 120
            
        }), completion:  { (finished: Bool) in
            
            self.topDirectionView.isHidden = false
            self.bottomDirectionView.isHidden = false
            
            self.progressMode.text = "Pick up"
            self.progressAddress.text = self.TripRiderResult.pickUpAddress
            let fullNameArr = self.TripRiderResult.pickUp_name.components(separatedBy: " ")
            self.riderName.text = fullNameArr[0].firstUppercased
            
            
            completed()
        })
        
        
    }
    
    func drawRouteForDriver(myLocation: CLLocationCoordinate2D, destinationed: CLLocationCoordinate2D, imageName: String, completed: @escaping DownloadComplete){
        
        mapView.clear()
        let origin = "\(myLocation.latitude),\(myLocation.longitude)"
        let destination = "\(destinationed.latitude),\(destinationed.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&sensor=true&key=\(googleMap_Key)"
        
        
        self.polyline.map = nil
        
        
        Alamofire.request(url).responseJSON { response in
            
            let json = try! JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                
                if let result = dict["routes"] as? [Dictionary<String, AnyObject>] {
                    
                    for i in result {
                        
                        if let x = i["legs"] as? [Dictionary<String, AnyObject>] {
                            
                            for y in x {
                                
                                if let z = y["duration"] as? Dictionary<String, AnyObject> {
                                    
                                    self.DriverEta = (z["text"] as? String)!
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
                
            }
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                self.path = GMSPath.init(fromEncodedPath: points!)!
                self.polyline = GMSPolyline.init(path: self.path)
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = UIColor.black
                self.polyline.map = self.mapView
                
                completed()
                
            }
            
            
            self.marker.position = myLocation
            
            self.marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            self.marker.map = self.mapView
            self.marker.isTappable = false
            
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            myView.backgroundColor = UIColor.clear
            self.marker.iconView = myView
            
            
            
            
            self.pulsator.position =  (self.marker.iconView!.center)
            self.marker.iconView?.layer.addSublayer(self.pulsator)
            self.marker.iconView?.backgroundColor = UIColor.clear
            
            
            
            
            myView.backgroundColor = UIColor.clear
            let IconImage = resizeImage(image: UIImage(named: "my")!, targetSize: CGSize(width: 20.0, height: 20.0))
            let markerView = UIImageView(image: IconImage)
            markerView.center = myView.center
            
            self.marker.appearAnimation = .pop
            myView.addSubview(markerView)
            
            var iconImages: UIImage!
            
            let desMarker = GMSMarker()
            
            if imageName == "user" {
                
                if self.avatarIcon != nil {
                    
                    iconImages = resizeImage(image: self.avatarIcon, targetSize: CGSize(width: 40.0, height: 40.0))
                    
                } else {
                    
                    iconImages = resizeImage(image: UIImage(named: imageName)!, targetSize: CGSize(width: 40.0, height: 40.0))
                    
                }
            }
            
            
            desMarker.position = destinationed
            desMarker.icon = iconImages
            desMarker.snippet = self.DriverEta
            desMarker.tracksViewChanges = true
            
            
            //gameMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.1)
            desMarker.map = self.mapView
            self.mapView.selectedMarker = desMarker
            
        }
        
    }
    

    @objc func cancelRide() {
        
        NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "cancelRide")), object: nil)
        SwiftLoader.hide()
        
    }

    
    func observeCancelFromRider(key: String) {
        
        
        handelCancelFromRider = DataService.instance.mainDataBaseRef.child("Cancel_request").child(userUID).child(key).observe(.value, with: { (cancelData) in
            
            
            
            
            if cancelData.exists() {
                
               
                
                
               self.capturePayment()
                DataService.instance.mainDataBaseRef.child("Cancel_request").child(userUID).child(key).removeObserver(withHandle: self.handelCancelFromRider!)
                DataService.instance.mainDataBaseRef.removeAllObservers()
                self.locationManager.stopUpdatingLocation()
                self.enableAcceptingRide()
                self.isAccepted = false
                
                self.topDirectionView.isHidden = true
                self.bottomDirectionView.isHidden = true
                self.showErrorAlert("Oops !!!", msg: "You rider has canceled this ride.")
                DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(self.TripRiderResult.rider_UID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Canceled", "Timestamp": ServerValue.timestamp()])
                
                DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(userUID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Canceled", "Timestamp": ServerValue.timestamp()])
                
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    
                    self.mapViewBottomConstraint.constant = 0
                    self.mapViewTopConstraint.constant = 0
                    
                }), completion:  { (finished: Bool) in
                    
                    self.pulsator.stop()
                    self.centerMapOnUserLocation()
                    
                })
                
                
                
            }
            
            
        })
        
        
    }
    
    
    @IBAction func driverReqestCancelBtnPressed(_ sender: Any) {
        
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Dismiss") {
            
        }
        _ = alert.addButton("Cancel trip") {
            
            DataService.instance.mainDataBaseRef.child("Cancel_request").child(self.TripRiderResult.rider_UID).child(self.current_request_trip_key).setValue(["Canceled": 1])
            
            DataService.instance.mainDataBaseRef.removeAllObservers()
            self.locationManager.stopUpdatingLocation()
            self.enableAcceptingRide()
            self.isAccepted = false
            
            self.topDirectionView.isHidden = true
            self.bottomDirectionView.isHidden = true
            
            
            
            //Progess
            
            let alert = JDropDownAlert()
            let color = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 0.9)
            alert.alertWith("Successfully canceled",
                            topLabelColor: UIColor.white,
                            messageLabelColor: UIColor.white,
                            backgroundColor: color)
            
                self.make_refund(capturedKey: self.TripRiderResult.capturedKey)
            DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(self.TripRiderResult.rider_UID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Canceled", "Timestamp": ServerValue.timestamp()])
            
            DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(userUID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Canceled", "Timestamp": ServerValue.timestamp()])
            
                DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(userUID).removeValue()
            
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                
                
                self.mapViewBottomConstraint.constant = 0
                self.mapViewTopConstraint.constant = 0
                
            }), completion:  { (finished: Bool) in
                
                self.pulsator.stop()
                self.centerMapOnUserLocation()
                
            })
            
            
        }
        
        let icon = UIImage(named:"lg1")
        
        _ = alert.showCustom("Notice !!!", subTitle: "Cancel ride could reduce your rate significantly. Just only cancel only in a necessary and important situation.", color: UIColor.black, icon: icon!)
        
        
    }
    
    
    // check rider signal
    
    func checkRiderSignalOnTrip(riderUID: String, key: String) {
        
        DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(key).child(riderUID).child("Request").setValue(["Request": 1])
        
        
        DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(key).child(riderUID).child("Response").observe(.value, with: { (response) in
            
            
            if response.exists() {
                
                DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(key).child(riderUID).child("Response").removeAllObservers()
                
                    self.signalResponse = 1
                
            }
            
            
            
            
        })
        
        
    
        
    }
    
    
    
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }


    // set payment

    
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "moveToProfileVC", sender: nil)
        
    }
    
    @IBAction func starBtnPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "moveToRatingVC", sender: nil)
        
    }
    
    @IBAction func switchDriverMode(_ sender: Any) {
        
        if switchBtn.isOn == true {
            
            enableAcceptingRide()
        } else {
            
            temporaryTerminateAcceptingRide()
        }
        
        
        
    }
    
    @IBAction func pickedUpBtnPressed(_ sender: Any) {
        
        
        
        // 1. update ui driver
        // 2. update observe for rider and driver
        // 3. redraw map
        
        UpdateUIAfterPickedUp()
        let Mylocation =  CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
        let destination = CLLocationCoordinate2D(latitude: self.TripRiderResult.Destination_Lat, longitude: self.TripRiderResult.Destination_Lon)
        
        
        DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(self.TripRiderResult.rider_UID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Pick up", "Timestamp": ServerValue.timestamp()])
        
        DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(userUID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Pick up", "Timestamp": ServerValue.timestamp()])
        
        
        DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Rider").child(self.TripRiderResult.rider_UID).removeValue()
        DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(userUID).removeValue()
        DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Rider").child(self.TripRiderResult.rider_UID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.TripRiderResult.Trip_key, "Driver_UID": userUID, "Rider_UID": self.TripRiderResult.rider_UID])
        DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(self.TripRiderResult.Trip_key).child(self.TripRiderResult.rider_UID).child("Response").removeAllObservers()
        
        DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Driver").child(userUID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.TripRiderResult.Trip_key, "Driver_UID": userUID, "Rider_UID": self.TripRiderResult.rider_UID])
        
        
        DataService.instance.mainDataBaseRef.child("Cancel_request").child(userUID).removeAllObservers()
        
        
        self.pulsator.stop()
        self.drawRouteForDriver(myLocation: Mylocation, destinationed: destination, imageName: "pin"){
            
            
            self.pulsator.start()
            self.fitAllMarkers(_path: self.path)
            self.UpdateObserveForRider()
            
            
            
        }
        
        
        
    }
    
    func UpdateObserveForRider() {
        
        
        DataService.instance.mainDataBaseRef.child("trip_progressed").child(self.TripRiderResult.rider_UID).child(self.TripRiderResult.Trip_key).setValue(["Status": "Picked up", "Timestamp": ServerValue.timestamp()])
        
    }
    
    
    func askForRating(Rider_UID: String, Driver_UID: String, Trip_key: String, Driver_Name: String) {
        
         DataService.instance.mainDataBaseRef.child("Missing_Rate").child("Rider").child(Rider_UID).observeSingleEvent(of: .value, with: { (Rate) in
            
            if Rate.exists() {
                
                if let dict = Rate.value as? Dictionary<String, Any> {
                    
                    
                    if let rate_id = dict["Trip_key"] as? String {
                        
                        
                        if rate_id == Trip_key {
                            
                            
                        } else {
                            DataService.instance.mainDataBaseRef.child("Missing_Rate").child("Rider").child(Rider_UID).setValue(["Driver_UID": Driver_UID, "Trip_key": Trip_key, "Driver_Name": Driver_Name] )
                            
                        }
                        
                        
                    }
                    
 
                    
                }
                
            } else {
                
                DataService.instance.mainDataBaseRef.child("Missing_Rate").child("Rider").child(Rider_UID).setValue(["Driver_UID": Driver_UID, "Trip_key": Trip_key])
                
                
            }
            
            
         })
        
        
        
        
    }
    
    
    
    @IBAction func contactBtnPressed(_ sender: Any) {
        
        makeAPhoneCall()
        
    }
    @IBAction func arriveBtnPressed(_ sender: Any) {
        
        
        locationManager.stopUpdatingLocation()
        isAccepted = false
        centerMapOnUserLocation()
        topDirectionView.isHidden = true
        bottomDirectionView.isHidden = true
        // charged capture the payment
        // create history dictionary for both rider and driver
        // popup rating system
        
        
        //Progess
        
        
        
            Zendrive.stopDrive(self.TripRiderResult.Trip_key)
        DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(self.TripRiderResult.rider_UID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Completed", "Timestamp": ServerValue.timestamp()])
        
        DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(userUID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Completed", "Timestamp": ServerValue.timestamp()])
        
        DataService.instance.mainDataBaseRef.child("Trip_History").child("Completed").child(userUID).child(self.TripRiderResult.Trip_key).updateChildValues(["Progess": "Paid", "Timestamp": ServerValue.timestamp()])
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            
            self.mapViewBottomConstraint.constant = 0
            self.mapViewTopConstraint.constant = 0
            
        }), completion:  { (finished: Bool) in
            
        
            self.rate_rider_uid = self.TripRiderResult.rider_UID
            self.trip_key = self.TripRiderResult.Trip_key
            self.pulsator.stop()
            self.centerMapOnUserLocation()
            self.capturePayment()
            self.updateUIForRating()
            DataService.instance.mainDataBaseRef.child("Missing_Rate").child("Driver").child(userUID).setValue(["Rider_UID": self.rate_rider_uid, "Trip_key": self.TripRiderResult.Trip_key])
            
            DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Rider").child(self.TripRiderResult.rider_UID).removeValue()
            DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Driver").child(userUID).removeValue()
            
            
            if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
                
                let fullNameArr = name?.components(separatedBy: " ")

                let firstName = fullNameArr![0].firstUppercased
                
                self.askForRating(Rider_UID: self.TripRiderResult.rider_UID, Driver_UID: userUID, Trip_key: self.TripRiderResult.Trip_key, Driver_Name: firstName)
                
            }
            
            
            
            
        })
        
    }
    
    
    func loadAverageRate(Rates: Float) {
        
        
        DataService.instance.mainDataBaseRef.child("Average_Rate").child("Rider").child(self.rate_rider_uid!).observeSingleEvent(of: .value, with: { (RateData) in
            
            if RateData.exists() {
                
                
                if let dict = RateData.value as? Dictionary<String, Any> {
                    
                    
                    if let RateGet = dict["Rate"] as? Float {
                        
                        
                        
                        let final = (RateGet + Rates) / 2
                        
                        print(final)
                        DataService.instance.mainDataBaseRef.child("Average_Rate").child("Rider").child(self.rate_rider_uid!).setValue(["Rate": final, "Timestamp": ServerValue.timestamp()])
                        
                    }
                    
                    
                }
                
                
            } else {
                
                
                DataService.instance.mainDataBaseRef.child("Average_Rate").child("Rider").child(self.rate_rider_uid!).setValue(["Rate": Rates, "Timestamp": ServerValue.timestamp()])
                
            }
            
            
        })
        
        
    }
    
    
    func checkIfRiderRateForRide() {
        
        
        DataService.instance.mainDataBaseRef.child("Missing_Rate").child("Driver").child(userUID).observeSingleEvent(of: .value, with: { (Rate) in
            
            
            if Rate.exists() {
                
                self.temporaryTerminateAcceptingRide()
                if let dict = Rate.value as? Dictionary<String, Any> {
                    
                
                    if let Trip_key = dict["Trip_key"] as? String {
                        
                        
                        if let Rider_UID = dict["Rider_UID"] as? String {
                            
                            
                            self.trip_key = Trip_key
                            self.rate_rider_uid = Rider_UID
                            self.updateUIForRating()
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
            } else {
                
                
                
                
                
            }
            
            
            
        })
        
        
        
    }
    
  
    
    @IBAction func SubmitRatingBtnPressed(_ sender: Any) {
        
        if rateCount != 0, self.rate_rider_uid != nil  {
            
            self.pulsator.stop()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                
                self.ratingView.frame = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: self.ratingView.frame.width, height: self.ratingView.frame.height)
                
                
            }), completion:  { (finished: Bool) in
                
                self.ratingView.isHidden = true
                self.blurView.isHidden = true
                self.view.endEditing(true)
                
                if self.ratingText.text == "" || self.ratingText.text == "Comment" {
                    
                    self.ratingText.text = "nil"
                    
                }
                
                if self.rateCount == 5 {
                    DataService.instance.mainDataBaseRef.child("Rating").child("Rider").child(self.rate_rider_uid!).child("Five_star").child(self.trip_key!).setValue(["Rate": self.rateCount, "Text": self.ratingText.text, "Key": self.trip_key!, "Timestamp": ServerValue.timestamp()])
                    
                }
                DataService.instance.mainDataBaseRef.child("Rating").child("Rider").child(self.rate_rider_uid!).child(self.trip_key!).setValue(["Rate": self.rateCount, "Text": self.ratingText.text, "Key": self.trip_key!, "Timestamp": ServerValue.timestamp()])
                
                    self.loadAverageRate(Rates: Float(self.rateCount))
                DataService.instance.mainDataBaseRef.child("Missing_Rate").child("Driver").child(userUID).removeValue()
                
                
                
                self.isAccepted = false
                self.IsSendMess = false
                self.IsDeliverMess = false
                self.toDestination = false
                self.ratingText.text = "Comment"
                
                
                self.enableAcceptingRide()
                
            })
            
        } else {
            
            
            self.showErrorAlert("Oops !!!", msg: "Please rate and comment your experience with the trip")
            
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if ratingView.isHidden != true {
            
            self.view.endEditing(true)
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if ratingText.text == "Comment" {
            
            ratingText.text = ""
            
            
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
        if ratingText.text == "Comment" ||  ratingText.text == ""{
            
            ratingText.text = "Comment"
            
            
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == ratingText {
            
            self.view.addGestureRecognizer(tapGesture)
            moveTextField(textField, moveDistance: -150, up: true)
            
        }
        
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == ratingText {
            
            moveTextField(textField, moveDistance: -150, up: false)
            
        }
        
    }
    
    func capturePayment() {
        
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("Capture_payment")
        
        
        
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            "chargedID": TripRiderResult.capturedKey!
   
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success(let json):
                    
                    
                    if json is [String: AnyObject] {
                        
                        
                        DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(self.TripRiderResult.rider_UID).child(self.TripRiderResult.Trip_key).updateChildValues(["ChargeStatus": "Paid"])
                        
                        DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(userUID).child(self.TripRiderResult.Trip_key).updateChildValues(["ChargeStatus": "Paid"])
                        
                        
                            self.prepare_payDriver(price: self.TripRiderResult.price)
                        
                        
                    }
                    
                    
                case .failure( _):
                    
                    DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(self.TripRiderResult.rider_UID).child(self.TripRiderResult.Trip_key).updateChildValues(["ChargeStatus": "Failed"])
                    
                    DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(userUID).child(self.TripRiderResult.Trip_key).updateChildValues(["ChargeStatus": "Failed"])
                    
                    self.showErrorAlert("Oops !!!", msg: "There is some error while capturing the payment, please contact us immediately")
                    
                }
                
                
        }
        
 
    }
    
    func prepare_payDriver(price: Double){
        DataService.instance.mainDataBaseRef.child("Stripe_Driver_Connect_Account").child(userUID).observeSingleEvent(of: .value, with: { (Connect) in
            
            if Connect.exists() {
                
                if let acc = Connect.value as? Dictionary<String, Any> {
                    
                    if let account = acc["Stripe_Driver_Connect_Account"] as? String {
              
                        let driverPrice = price * 60
                        self.make_payment_driver(price: driverPrice, account: account)
                        
                        
                    }
                    
                }
            }
            
        })
        
  
    }
    
    func notiWhenTip() {
        
        
        DataService.instance.mainDataBaseRef.child("TipNoti").child(userUID).observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                
                
                DataService.instance.mainDataBaseRef.child("TipNoti").child(userUID).child(snapshot.key).removeValue()
                
                if let RiderName  = dict["RiderName"] as? String, let Timestamp = dict["Timestamp"], let Price = dict["Price"] as? Double {
                    
                    let time = Timestamp as? TimeInterval
                    
                    let date = Date(timeIntervalSince1970: time!/1000)
                    let timeFormatter = DateFormatter()
                    timeFormatter.timeStyle = DateFormatter.Style.short
                    let times = timeFormatter.string(from: date)
                    
                    let sms = "You have recieved $\(Price/100)0 from \(RiderName) at \(times). You can check it out in the payment setting and you will receive your money on the next business day"
                    
                    LocalNotification.dispatchlocalNotification(with: "Congratulations", body: sms)
                    
                    
                    
                    
                    
                }
                
            }
            
        })
        
        
        
    }
    
  
    
    func make_refund(capturedKey: String) {
        
        
        if capturedKey != "" {
            
            
            let currentDateTime = Date()
            
            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            // get the date time String from the date object
            let result = formatter.string(from: currentDateTime)
            let description = "Release from pre-authorize for taking a ride from Campus Connect at \(result)"
            
            let url = MainAPIClient.shared.baseURLString
            let urls = URL(string: url!)?.appendingPathComponent("refund")
            
            Alamofire.request(urls!, method: .post, parameters: [
                
                "refund_key": self.capturedKey,
                "reason": description
                
                ])
                
                .validate(statusCode: 200..<500)
                .responseJSON { responseJSON in
                    
                    switch responseJSON.result {
                        
                    case .success(let json):
                        
                        
                        if let dict = json as? [String: AnyObject] {
                            
                            
                            print(dict)
                            
                        }
                        
                    case .failure( _):
                        
                        self.showErrorAlert("Oops !!!", msg: "There is a problem while returning your money, please contact us for manual refund.")
                        
                    }
                    
                    
            }
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    func make_payment_driver(price: Double, account: String){
        
        
        let fPrice = Int(price)
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("Transfer_payment")
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            "price": fPrice,
            "account": account
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success(let json):
                    
                    
                    print(json)
                    
                    
                    
                case .failure( _):
                    
                    
                    
                    self.showErrorAlert("Oops !!!", msg: "Due to some unknown errors, we can't pay you now. Please contact us to solve the issue")
                    
                }
                
                
        }
        
        
    }
    
    
    
    func UpdateUIAfterPickedUp() {
        
        
        
        progressMode.text = "Go to"
        progressAddress.text = self.TripRiderResult.destinationAddress
        pickUpView.isHidden = true
        cancelView.isHidden = true
        arriveBtn.isHidden = false
        toDestination = true
        
        self.navigationCoordinate = CLLocationCoordinate2D(latitude: self.TripRiderResult.Destination_Lat, longitude: self.TripRiderResult.Destination_Lon)
        
    }
    
    
    func makeAPhoneCall()  {
        
        let phone = self.TripRiderResult.PickUp_Phone.dropFirst().dropFirst()
        
        
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            print("Cannot Call")
            
        }
        
        
    }
    
    @IBAction func navigationBtnPressed(_ sender: Any) {
        
        let sheet = UIAlertController(title: "Which map do you want to use ?", message: "", preferredStyle: .actionSheet)
        
        
        let googleMap = UIAlertAction(title: "Google Map", style: .default) { (alert) in
            
            self.launchGoogleMap()
            
        }
        
        let appleMap = UIAlertAction(title: "Apple Map", style: .default) { (alert) in
            
            self.AppleMap()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        
        sheet.addAction(googleMap)
        sheet.addAction(appleMap)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    func launchGoogleMap() {
        
        
        if progressMode.text == "Pick up" {
            
            let Deslatitude: CLLocationDegrees = navigationCoordinate.latitude
            let Deslongitude: CLLocationDegrees = navigationCoordinate.longitude
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.openURL(URL(string:"comgooglemaps://?saddr=&daddr=\(Deslatitude),\(Deslongitude)&directionsmode=driving")!)
            }
            
            
        } else {
            
            let Deslatitude: CLLocationDegrees = navigationCoordinate.latitude
            let Deslongitude: CLLocationDegrees = navigationCoordinate.longitude
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.openURL(URL(string:"comgooglemaps://?saddr=&daddr=\(Deslatitude),\(Deslongitude)&directionsmode=driving")!)
            }
            
            
        }
        
        
        
    }
    
    
    func AppleMap() {
        
        if progressMode.text == "Pick up" {
            
            let latitude: CLLocationDegrees = navigationCoordinate.latitude
            let longitude: CLLocationDegrees = navigationCoordinate.longitude
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = placeName
            mapItem.openInMaps(launchOptions: options)
            
            
        } else {
            
            
            
            
            let latitude: CLLocationDegrees = navigationCoordinate.latitude
            let longitude: CLLocationDegrees = navigationCoordinate.longitude
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = placeName
            mapItem.openInMaps(launchOptions: options)
            
            
            
            
        }
        
        
        
    }

    
    
    func temporaryTerminateAcceptingRide() {
        
        alertView.isHidden = true
        switchBtn.isOn = false
        
        locationManager.stopUpdatingLocation()
        
        DataService.instance.mainDataBaseRef.child("Driver_coordinator").child(userUID).removeValue()
        
        
        
    }
    
    
    func enableAcceptingRide() {
        
        
        alertView.isHidden = false
        switchBtn.isOn = true
        if isConnected == true {
            
            alertView.backgroundColor = UIColor.yellow
            alertLbl.text = "Finding Rides…"
            alertLbl.textColor = UIColor.darkGray
            
            DataService.instance.mainDataBaseRef.child("Pending_driver").child(userUID).removeValue()
            
            locationManager.startUpdatingLocation()
            
            
            DispatchQueue.global(qos: .background).async {
                print("Run on background thread")
                self.Driver_observeTrip()
            }
 
            
            
            
            
            
            
        }
        
        
    }
    
    

    
    
    
    //func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func showErrorAlertSignOut(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { (alert) in
            
            try! Auth.auth().signOut()
            
            
            try? InformationStorage?.removeAll()
            DataService.instance.mainDataBaseRef.removeAllObservers()
            self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
            
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.white
        config.spinnerColor = UIColor.black
        config.titleTextColor = UIColor.darkGray
        
        config.spinnerLineWidth = 5.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        config.speed = 6
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "Finding driver", animated: true)
        
    }
    
    
    
    
    func sendSmsNoti(Phone: String, text: String) {
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("sms_noti")
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            "phone": Phone,
            "body": text
            
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                    
                case .success(let json):
                    
                    print( json)
                    
                case .failure(let err):
                    
                    print(err)
                }
                
        }
        
    }
    
    func setupProgress() {
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 5, width: 30, height: 30))
        //progress.center = progressView.center
        progress.clockwise = true
        progress.progressThickness = 0.5
        progress.trackThickness = 0.7
        progress.gradientRotateSpeed = 2
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.trackColor = UIColor.groupTableViewBackground.withAlphaComponent(0.5)
        progress.progressColors = [UIColor.white]
        progress.startAngle = -90
        
        progressView.addSubview(progress)
        
    }
    
    @IBAction func driverHistoryBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "TripHistoryVC", sender: nil)
        
    }
    
    @IBAction func driverPaymentBtnPressed(_ sender: Any) {
        
       // self.performSegue(withIdentifier: "moveToEarningVC", sender: nil)
        retrieve_earningAccount()
        
    }
    
    
    func retrieve_earningAccount() {
        
        DataService.instance.mainDataBaseRef.child("Stripe_Driver_Connect_Account").child(userUID).observeSingleEvent(of: .value, with: { (Connect) in
            
            if Connect.exists() {
                
                if let acc = Connect.value as? Dictionary<String, Any> {
                    
                    if let Login_link = acc["Login_link"] as? String {
                        
                        
                        guard let urls = URL(string: Login_link) else {
                            return //be safe
                        }
                        
                        let vc = SFSafariViewController(url: urls)
                        
                        
                        self.present(vc, animated: true, completion: nil)
                        
                        
                    }
                    
                }
            }
            
            
            
        })
        
        
    }
    
    @IBAction func driverAboutUsBtnPressed(_ sender: Any) {
        
        
       openCCWebsite()
        
    }
    
    @IBAction func driverReportBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToReportVC", sender: nil)
    }
    
    @IBAction func driverHelpBtnPressed(_ sender: Any) {
        
        
        openCCWebsite()
        
        
    }
    
    @IBAction func driverSignOutBtnPressed(_ sender: Any) {
        
        try! Auth.auth().signOut()
        
        
        try? InformationStorage?.removeAll()
        DataService.instance.mainDataBaseRef.removeAllObservers()
        self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
        
    }
    
    func openCCWebsite() {
        
        
        guard let url = URL(string: "http://campusconnectonline.com") else {
            return //be safe
        }
        
        let vc = SFSafariViewController(url: url)
        
        
        present(vc, animated: true, completion: nil)
        
    }
}

extension MapView: CLLocationManagerDelegate {
    
    // check if auth is not nil then request auth
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // get my location with zoom 30
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            
            centerMapOnUserLocation()
            
        }
        
    }
    
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        
    }
}





extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
extension Date {
    func addedBy(minutes:Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

