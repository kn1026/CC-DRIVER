//
//  photoOfCarVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/4/18.
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
import SwiftOCR

class photoOfCarVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var add1Btn: UIButton!
    @IBOutlet weak var add2Btn: UIButton!
    
    var carNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // var Car1Photo: UIImage?
      //  var Car2Photo: UIImage?
        
        
        if Car1Photo != nil, Car2Photo != nil {
            
            add1Btn.setImage(Car1Photo, for: .normal)
            add2Btn.setImage(Car2Photo, for: .normal)
            
            
        }
        
        
        
        
    }
    
    @IBAction func addFirstPhotoBtnPressed(_ sender: Any) {
        
        carNum = 1
        uploadCarPhoto()
    }
    
    @IBAction func addSecondPhotoBtnPressed(_ sender: Any) {
        
        
        carNum = 2
        uploadCarPhoto()
        
    }
    
    func uploadCarPhoto() {
        
        let sheet = UIAlertController(title: "Upload our car photo", message: "", preferredStyle: .actionSheet)
        
        
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
    
    // get media
    
    func getMediaFrom(_ type: String) {
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    func getMediaCamera(_ type: String) {
        
        
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true
        mediaPicker.mediaTypes = [type as String] //UIImagePickerController.availableMediaTypes(for: .camera)!
        mediaPicker.sourceType = .camera
        self.present(mediaPicker, animated: true, completion: nil)
        
    }
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        if add1Btn.imageView?.image != nil , add2Btn.imageView?.image != nil {
            
            Car1Photo = add1Btn.imageView?.image
            Car2Photo = add2Btn.imageView?.image
            photoOfCar = true
            
            self.dismiss(animated: true, completion: nil)
            
            
        } else {
                
         
            print("Empty")
            
            
        }
        
    }
    
    
    func getImage(image: UIImage) {
        
        
        if carNum == 1 {
            
        
            add1Btn.setImage(image, for: .normal)
            
        } else if carNum == 2 {
            
            
            add2Btn.setImage(image, for: .normal)
            
        }
        

        
        
        // done
    }
    

    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension photoOfCarVC: UIImagePickerControllerDelegate {
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
