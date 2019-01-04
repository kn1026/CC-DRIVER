//
//  Dataservice.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/25/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
let FIR_CHILD_USERS = "User_Info"
let main = "Campus-Connect"

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage




class DataService {
    
    
    
    fileprivate static let _instance = DataService()
   
    
    static var instance: DataService {
        return _instance
    }
    
    
   
    
    
    var mainDataBaseRef: DatabaseReference {
        return Database.database().reference().child(main)
    }
    
    var REF_RIDERS: DatabaseReference {
        return mainDataBaseRef.child("riders")
    }
    
    var REF_DRIVERS: DatabaseReference {
        return mainDataBaseRef.child("drivers")
    }
    
    var REF_TRIPS: DatabaseReference {
        return mainDataBaseRef.child("trips")
    }
    
    
    var fcmTokenUserRef: DatabaseReference {
        return mainDataBaseRef.child("fcmToken")
    }
  
    var checkPhoneUserRef: DatabaseReference {
        return mainDataBaseRef.child("Phone")
    }
    
    var checkEmailUserRef: DatabaseReference {
        return mainDataBaseRef.child("Email")
    }
    
    var CoordinateRef: DatabaseReference {
        return mainDataBaseRef.child("Game_Coordinate")
    }
    
    var UsersRef: DatabaseReference {
        return mainDataBaseRef.child(FIR_CHILD_USERS)
    }
   

    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://campus-ca92f.appspot.com/")
    }
    
    var VideoStorageRef: StorageReference {
        return mainStorageRef.child("Video_Introduction")
    }
    
    var AvatarStorageRef: StorageReference {
        return mainStorageRef.child("Avatar")
    }
    var SSStorageRef: StorageReference {
        return mainStorageRef.child("Social security")
    }
    var DriverLicsStorageRef: StorageReference {
        return mainStorageRef.child("Driver license")
    }
    var LicsPlateStorageRef: StorageReference {
        return mainStorageRef.child("License plate")
    }
    var CarRegistStorageRef: StorageReference {
        return mainStorageRef.child("Car registration")
    }
    var PhotoOfCarStorageRef: StorageReference {
        return mainStorageRef.child("Car photo")
    }
    var ChatImageStorageRef: StorageReference {
        return mainStorageRef.child("Chat Image")
    }
    
    
    
    func saveUser(_ uid: String) {
        mainDataBaseRef.child(FIR_CHILD_USERS).child(uid).child("User")
        
    }
    
    let connectedRef = Database.database().reference(withPath: ".info/connected")
    
    
    
    
    
    
}
