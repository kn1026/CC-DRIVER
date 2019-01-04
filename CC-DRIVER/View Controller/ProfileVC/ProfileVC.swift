//
//  ProfileVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/2/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import Firebase
import FirebaseAuth
import Alamofire
import Cache


class ProfileVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var uniTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var firstNameTxtField: UITextField!
    
    @IBOutlet weak var userImg: UIImageView!
    
    var Changedimage: UIImage!
    
    var firstName: String?
    var lastName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        uniTxtField.layer.borderColor = UIColor.darkGray.cgColor
        uniTxtField.layer.borderWidth = 1.0
        uniTxtField.layer.cornerRadius = 6.0
        
        uniTxtField.delegate = self
        emailTxtField.delegate = self
        phoneTxtField.delegate = self
        
        
      
        
        if let CacheavatarImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: "avatarImg").image {
            
            userImg.isHidden = false
            userImg.image = CacheavatarImg
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let campus = try? InformationStorage?.object(ofType: String.self, forKey: "campus") {
            
            uniTxtField.placeholder = campus
            
        }
        
        
        if let phone = try? InformationStorage?.object(ofType: String.self, forKey: "phone") {
            
            if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
                
                if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
                    
                    phoneTxtField.placeholder = phone
                    emailTxtField.placeholder = email
                    let fullNameArr = name?.components(separatedBy: " ")
                    firstNameTxtField.placeholder = fullNameArr![0].firstUppercased
                    lastNameTxtField.placeholder = fullNameArr![(fullNameArr?.count)! - 1].firstUppercased
                    
                    
                    
                    firstName = fullNameArr![0].firstUppercased
                    lastName = fullNameArr![(fullNameArr?.count)! - 1].firstUppercased
                }
                
                
            }
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        
        if textField == uniTxtField {
            
            self.view.endEditing(true)
            
            self.performSegue(withIdentifier: "moveToChangeSchoolVC", sender: nil)
            
        } else if textField == phoneTxtField {
            
            self.view.endEditing(true)
            
            self.performSegue(withIdentifier: "moveToChangePhoneVC", sender: nil)
            
        } else if textField == emailTxtField {
            
            self.view.endEditing(true)
            
            self.performSegue(withIdentifier: "moveToChangeEmailVC", sender: nil)
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
        
    }
    
    
    func changePhoto() {
        
        
        let sheet = UIAlertController(title: "Change your profile photo", message: "", preferredStyle: .actionSheet)
        
        
        let camera = UIAlertAction(title: "Take a new photo", style: .default) { (alert) in
            
            self.camera()
            
        }
        
        let album = UIAlertAction(title: "Upload from album", style: .default) { (alert) in
            
           self.album()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        
        sheet.addAction(camera)
        sheet.addAction(album)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
        
        
        
    }
    
    func album() {
        
        self.getMediaFrom(kUTTypeImage as String)
        
        
    }
    
    func camera() {
        
        
        
        self.getMediaCamera(kUTTypeImage as String)
        
    }
    
    func getMediaCamera(_ type: String) {
        
        
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true
        mediaPicker.mediaTypes = [type as String] //UIImagePickerController.availableMediaTypes(for: .camera)!
        mediaPicker.sourceType = .camera
        self.present(mediaPicker, animated: true, completion: nil)
        
    }
    
    // get media
    
    func getMediaFrom(_ type: String) {
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func changePhotoBtnPressed(_ sender: Any) {
        
        
        changePhoto()
        
    }
    
    
    
    

    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if firstNameTxtField.text != "", lastNameTxtField.text != ""{
            
            print("Changed both name")
            let name = firstNameTxtField.text! + " " + lastNameTxtField.text!
            
            
            try? InformationStorage?.removeObject(forKey: "user_name")
            try? InformationStorage?.setObject(name, forKey: "user_name")
            DataService.instance.mainDataBaseRef.child("User").child(userUID).updateChildValues(["user_name": name])
            
            
            firstNameTxtField.placeholder = firstNameTxtField.text
            lastNameTxtField.placeholder = lastNameTxtField.text
            
            firstNameTxtField.text = ""
            lastNameTxtField.text = ""
           
            
            
            
        } else if lastNameTxtField.text == "", firstNameTxtField.text != "" {
            
            let name = firstNameTxtField.text! + " " + lastName!
            try? InformationStorage?.removeObject(forKey: "user_name")
            try? InformationStorage?.setObject(name, forKey: "user_name")
            DataService.instance.mainDataBaseRef.child("User").child(userUID).updateChildValues(["user_name": name])
            
            firstNameTxtField.placeholder = firstNameTxtField.text

            
            firstNameTxtField.text = ""
            lastNameTxtField.text = ""
            
            
        } else if firstNameTxtField.text == "", lastNameTxtField.text != "" {
            
            
            
            let name = firstName! + " " + lastNameTxtField.text!
            try? InformationStorage?.removeObject(forKey: "user_name")
            try? InformationStorage?.setObject(name, forKey: "user_name")
            DataService.instance.mainDataBaseRef.child("User").child(userUID).updateChildValues(["user_name": name])
            
            
            
            lastNameTxtField.placeholder = lastNameTxtField.text
            
            firstNameTxtField.text = ""
            lastNameTxtField.text = ""
            
        }
        
        if Changedimage != nil {
            
            
            if let img = userImg.image {
                
                self.swiftLoader()
                let metaData = StorageMetadata()
                let imageUID = UUID().uuidString
                metaData.contentType = "image/jpeg"
                var imgData = Data()
                imgData = UIImageJPEGRepresentation(img, 1.0)!
                
                
                
                DataService.instance.AvatarStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
                    
                    if err != nil {
                        
                        SwiftLoader.hide()
                        self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                        print(err?.localizedDescription as Any)
                        
                    } else {
                        
                        DataService.instance.AvatarStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                            
                            
                            guard let Url = url?.absoluteString else { return }
                            
                            let downUrl = Url as String
                            let downloadUrl = downUrl as NSString
                            let downloadedUrl = downloadUrl as String
                            
                            SwiftLoader.hide()
                            
                            if (try? InformationStorage?.object(ofType: String.self, forKey: "avatarUrl")) != nil {
                                
                                
                                try? InformationStorage?.removeObject(forKey: "avatarUrl")
                                try? InformationStorage?.removeObject(forKey: "avatarImg")
                                
                                try? InformationStorage?.setObject(downloadedUrl, forKey: "avatarUrl")
                                let wrapper = ImageWrapper(image: img)
                                try? InformationStorage?.setObject(wrapper, forKey: "avatarImg")
                                
                            } else {
                                
                                
                                try? InformationStorage?.setObject(downloadedUrl, forKey: "avatarUrl")
                                let wrapper = ImageWrapper(image: img)
                                try? InformationStorage?.setObject(wrapper, forKey: "avatarImg")
                                
                                
                            }
                            
                            
                            DataService.instance.mainDataBaseRef.child("User").child(userUID).updateChildValues(["avatarUrl": downloadedUrl])
                            SwiftLoader.hide()
                            
                        })
                        
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            } else {
                
                
                print("Nil")
                
            }
            
            
            
        }
        
  
        
    }
    
    func getImage(image: UIImage) {
        
        userImg.isHidden = false
        userImg.image = image
        Changedimage = image
        //profileImgView.image = image
        //imageProfile = image
        //changedImg = image
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

extension ProfileVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            getImage(image: editedImage)
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            getImage(image: originalImage)
        }
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
}


