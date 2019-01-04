//
//  becomeADriverVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/28/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase
import Cache
import SCLAlertView

class becomeADriverVC: UIViewController {

    @IBOutlet weak var socialBtn: UIButton!
    @IBOutlet weak var driverLicsBtn: UIButton!
    @IBOutlet weak var LicPlateBtn: UIButton!
    @IBOutlet weak var pictureOfCarBtn: UIButton!
    @IBOutlet weak var shippingBtn: UIButton!
    @IBOutlet weak var carRegistration: UIButton!
    
    
    @IBOutlet weak var submittedBtn: UIButton!
    @IBOutlet weak var socialTick: UIImageView!
    @IBOutlet weak var DriverLicsTick: UIImageView!
    @IBOutlet weak var LicsPlateTick: UIImageView!
    @IBOutlet weak var pictureOfCarTick: UIImageView!
    
    @IBOutlet weak var carRegistrationTick: UIImageView!
    
    @IBOutlet weak var shippingAddressTick: UIImageView!

    var SSdownloadUrl: String?
    var DriverLicdownloadUrl: String?
    var LicPlatedownloadUrl: String?
    var CarRegistdownloadUrl: String?
    var Car1downloadUrl: String?
    var Car2downloadUrl: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setAlignmentForBnt()
        
        
        isShippingDone = false
        isCarRegistrationDone = false
        DriverLics = false
        LicsPlate = false
        photoOfCar = false
        socialSecurity = false
        
        
        socialSecurityImg = nil
        LicPlateImg = nil
        DriverLicImg = nil
        CarRegistImg = nil
        Car1Photo = nil
        Car2Photo = nil
        
        
        Selectedadd1Txt = ""
        Selectedadd2Txt = ""
        SelectedCityTxt = ""
        SelectedStateTxt = ""
        SelectedzipcodeTxt = ""
        
    }
    
    func uploadSocialImg(image: UIImage?, completed: @escaping DownloadComplete) {
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image!, 1.0)!
        
        
        
        DataService.instance.SSStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                DataService.instance.SSStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
                    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    
                    
                    self.SSdownloadUrl = downloadedUrl
                    
                    
                    completed()
                })
                
            }
            
            
        }
        
    }
    
    func uploadLicPlateImg(image: UIImage?, completed: @escaping DownloadComplete) {
        
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image!, 1.0)!
        
        
        
        DataService.instance.LicsPlateStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                
                DataService.instance.LicsPlateStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
                    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    
                    
                    self.LicPlatedownloadUrl = downloadedUrl
                    
                    
                    completed()
                })
                
                
                
                
            }
            
            
        }
    }
    
    func uploadDriverLicImg(image: UIImage?, completed: @escaping DownloadComplete) {
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image!, 1.0)!
        
        
        
        DataService.instance.DriverLicsStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                
                DataService.instance.DriverLicsStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    
                    self.DriverLicdownloadUrl = downloadedUrl
                    
                    
                    completed()
                })
                
                
            }
            
            
        }
        
    }
    
    func uploadCarRegistImg(image: UIImage?, completed: @escaping DownloadComplete) {
        
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image!, 1.0)!
        
        
        
        DataService.instance.CarRegistStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                DataService.instance.CarRegistStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
                    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    
                    
                    self.CarRegistdownloadUrl = downloadedUrl
                    
                    
                    completed()
                })
                
                
                
                
            }
            
            
        }
    }
    
    func uploadCarPhotoImg(image1: UIImage?, image2: UIImage?, completed: @escaping DownloadComplete) {
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image1!, 1.0)!
        
        
        
        DataService.instance.PhotoOfCarStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                
                
                DataService.instance.PhotoOfCarStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
                    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    self.Car1downloadUrl = downloadedUrl
                    
                    
                    let imageUIDs = UUID().uuidString
                    imgData = UIImageJPEGRepresentation(image2!, 1.0)!
                    DataService.instance.CarRegistStorageRef.child(imageUIDs).putData(imgData, metadata: metaData) { (meta, err) in
                        
                        if err != nil {
                            
                            SwiftLoader.hide()
                            self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                            print(err?.localizedDescription as Any)
                            
                        } else {
                            
                            
                            DataService.instance.CarRegistStorageRef.child(imageUIDs).downloadURL(completion: { (url, err) in
                                guard let Url = url?.absoluteString else { return }
                                
                                let downUrl = Url as String
                                let downloadUrl = downUrl as NSString
                                let downloadedUrl = downloadUrl as String
                                self.Car2downloadUrl = downloadedUrl
                                completed()
                            })
                            
                            
                            
                            
                        }
                        
                        
                    }
                })
                
                
                
                
            }
            
            
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if isShippingDone != false {
            
            shippingAddressTick.isHidden = false
            
        }
        if isCarRegistrationDone != false {
            
            carRegistrationTick.isHidden = false
            
        }
        if DriverLics != false {
            
            DriverLicsTick.isHidden = false
            
        }
        if LicsPlate != false {
            
            LicsPlateTick.isHidden = false
            
        }
        if photoOfCar != false {
            
            pictureOfCarTick.isHidden = false
            
        }
        if socialSecurity != false {
            
            socialTick.isHidden = false
            
        }
        
        if isShippingDone != false, isCarRegistrationDone != false, DriverLics != false, LicsPlate != false, photoOfCar != false, socialSecurity != false {
            
            
            submittedBtn.setTitleColor(UIColor.black, for: .normal)
            
            
            
        } else {
            
            
            submittedBtn.setTitleColor(UIColor.groupTableViewBackground, for: .normal)
            
            
        }
        
        
        
    }
    
    func setAlignmentForBnt() {
        
        
        socialBtn.contentHorizontalAlignment = .left
        driverLicsBtn.contentHorizontalAlignment = .left
        LicPlateBtn.contentHorizontalAlignment = .left
        pictureOfCarBtn.contentHorizontalAlignment = .left
        shippingBtn.contentHorizontalAlignment = .left
        carRegistration.contentHorizontalAlignment = .left
        
    }
    

    @IBAction func backBtn1Pressed(_ sender: Any) {
        
       
        let sheet = UIAlertController(title: "Are you sure to go back? ", message: "If you go back, all your information will be cleared and you need to fill out all the forms again", preferredStyle: .alert)
        
        
        let oke = UIAlertAction(title: "Ok", style: .default) { (alert) in
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
            
           
            
        }
        
        
        
        sheet.addAction(oke)
        sheet.addAction(cancel)
        present(sheet, animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn2Pressed(_ sender: Any) {
        
        
        
        let sheet = UIAlertController(title: "Are you sure to go back?", message: "If you go back, all your information will be cleared and you need to fill out all the forms again", preferredStyle: .alert)
        
        
        let oke = UIAlertAction(title: "Ok", style: .default) { (alert) in
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
            
            
            
        }
        
        
        
        sheet.addAction(oke)
        sheet.addAction(cancel)
        present(sheet, animated: true, completion: nil)
        
    }
    
    @IBAction func moveToDriverLicsBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToDriverLicVC", sender: nil)
        
        
    }
    
    @IBAction func moveToSocialBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToSocialVC", sender: nil)
        
    }
    
    @IBAction func moveToLicPlateBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToLicPlateVC", sender: nil)
        
    }
    
    @IBAction func moveToPictureOfCarBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToPhotoOfCarVC", sender: nil)
        
    }
    
    @IBAction func moveToCarRegistrationBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToCarRegistrationVC", sender: nil)
        
    }
    
    @IBAction func moveToShippingAddressBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToShippingVC", sender: nil)
        
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        
        if isShippingDone != false, isCarRegistrationDone != false, DriverLics != false, LicsPlate != false, photoOfCar != false, socialSecurity != false {
            
            swiftLoader()
            
            uploadSocialImg(image: socialSecurityImg) {
                
                
                self.uploadLicPlateImg(image: LicPlateImg) {
                    
                    
                    self.uploadCarRegistImg(image: CarRegistImg) {
                        
                        
                        
                        
                        self.uploadDriverLicImg(image: DriverLicImg) {
                            
                            
                            
                            self.uploadCarPhotoImg(image1: Car1Photo, image2: Car2Photo) {
                                
                                
                            
                                
                                
                                if let phone = try? InformationStorage?.object(ofType: String.self, forKey: "phone") {
                                    
                                    if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
                                        
                                        if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
                                            
                                             if let campus = try? InformationStorage?.object(ofType: String.self, forKey: "campus") {
                                            
                                                if Selectedadd2Txt != "" {
                                                    
                                                    let Application: Dictionary<String, AnyObject> = ["SSdownloadUrl": self.SSdownloadUrl as AnyObject, "DriverLicdownloadUrl": self.DriverLicdownloadUrl as AnyObject, "LicPlatedownloadUrl": self.LicPlatedownloadUrl as AnyObject, "CarRegistdownloadUrl": self.CarRegistdownloadUrl as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "Car1downloadUrl": self.Car1downloadUrl as AnyObject, "Car2downloadUrl": self.Car2downloadUrl as AnyObject, "campus": campus as AnyObject, "email": email as AnyObject, "user_name": name as AnyObject, "phone": phone as AnyObject,"Selectedadd1Txt": Selectedadd1Txt as AnyObject, "Selectedadd2Txt": Selectedadd2Txt as AnyObject, "SelectedCityTxt": SelectedCityTxt as AnyObject, "SelectedStateTxt": SelectedStateTxt as AnyObject, "SelectedzipcodeTxt": SelectedzipcodeTxt as AnyObject]
                                                    DataService.instance.mainDataBaseRef.child("Application_Request").child("New").child(userUID).setValue(Application)
                                                    DataService.instance.mainDataBaseRef.child("Application_Request").child("Total").child(userUID).setValue(Application)
                                                    
                                                    
                                                } else {
                                                    
                                                    let Application: Dictionary<String, AnyObject> = ["SSdownloadUrl": self.SSdownloadUrl as AnyObject, "DriverLicdownloadUrl": self.DriverLicdownloadUrl as AnyObject, "LicPlatedownloadUrl": self.LicPlatedownloadUrl as AnyObject, "CarRegistdownloadUrl": self.CarRegistdownloadUrl as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "Car1downloadUrl": self.Car1downloadUrl as AnyObject, "Car2downloadUrl": self.Car2downloadUrl as AnyObject, "campus": campus as AnyObject, "email": email as AnyObject, "user_name": name as AnyObject, "phone": phone as AnyObject,"Selectedadd1Txt": Selectedadd1Txt as AnyObject, "Selectedadd2Txt": "nil" as AnyObject, "SelectedCityTxt": SelectedCityTxt as AnyObject, "SelectedStateTxt": SelectedStateTxt as AnyObject, "SelectedzipcodeTxt": SelectedzipcodeTxt as AnyObject]
                                                    
                                                    
                                                    DataService.instance.mainDataBaseRef.child("Application_Request").child("New").child(userUID).setValue(Application)
                                                    DataService.instance.mainDataBaseRef.child("Application_Request").child("Total").child(userUID).setValue(Application)
                                                    
                                                }
                                                
                                                
                                                SwiftLoader.hide()
                                                
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
                                                
                                                _ = alert.showCustom("Congratulation !!!", subTitle: "You successfully submitted the application to become a driver at Campus Connect, we will process your application soon and let you know through email and phone", color: UIColor.black, icon: icon!)

                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                               
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
            }
            
            
        } else {
            
            
            
            
            
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
