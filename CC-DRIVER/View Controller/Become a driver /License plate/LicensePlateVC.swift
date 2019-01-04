//
//  LicensePlateVC.swift
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

class LicensePlateVC: UIViewController, UINavigationControllerDelegate {
    
    
    
    let swiftOCRInstance = SwiftOCR()
    
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var plateImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if LicPlateImg != nil {
            
            previewView.isHidden = false
            plateImg.image = LicPlateImg
            
        }
        
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        
        let sheet = UIAlertController(title: "Upload our license plate", message: "", preferredStyle: .actionSheet)
        
        
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
    
    func getImage(image: UIImage) {
        
        
        plateImg.image = image
        previewView.isHidden = false
        
        let img = swiftOCRInstance.preprocessImageForOCR(image)
        
        swiftOCRInstance.recognize(img) { recognizedString in
            print(recognizedString)
        }
        
        
        
        // done
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        previewView.isHidden = true
        plateImg.image = nil
        
    }

    @IBAction func cancel1BtnPressed(_ sender: Any) {
        
        previewView.isHidden = true
        plateImg.image = nil
        
    }
    
    @IBAction func retakeBtnPressed(_ sender: Any) {
        
        let sheet = UIAlertController(title: "Upload our license plate", message: "", preferredStyle: .actionSheet)
        
        
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
    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        LicsPlate = true
        LicPlateImg = plateImg.image
        self.dismiss(animated: true, completion: nil)
        
        
    }
}

extension LicensePlateVC: UIImagePickerControllerDelegate {
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
