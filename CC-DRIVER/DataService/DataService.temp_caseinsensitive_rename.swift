//
//  Dataservice.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/25/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
let FIR_CHILD_USERS = "User_Info"
let CRACC = "CRACC"

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
        return Database.database().reference().child(CRACC)
    }
    
    var nickNameDataRef: DatabaseReference {
        return mainDataBaseRef.child("NickCheck")
    }
    
    var fcmTokenUserRef: DatabaseReference {
        return mainDataBaseRef.child("fcmToken")
    }
    
    var checkFacebookUserRef: DatabaseReference {
        return mainDataBaseRef.child("Facebook")
    }
    var checkNickNameUserRef: DatabaseReference {
        return mainDataBaseRef.child("Nickname")
    }
    var checkGoogleUserRef: DatabaseReference {
        return mainDataBaseRef.child("Google")
    }
    var checkEmailUserRef: DatabaseReference {
        return mainDataBaseRef.child("Email")
    }
    
    var GameChatRef: DatabaseReference {
        return mainDataBaseRef.child("Game_Chat")
    }
    var NormalChatRef: DatabaseReference {
        return mainDataBaseRef.child("Personal_Chat")
    }
    
    var GamePostRef: DatabaseReference {
        return mainDataBaseRef.child("Game_Post")
    }
    
    var GameCoordinateRef: DatabaseReference {
        return mainDataBaseRef.child("Game_Coordinate")
    }
    
    var UsersRef: DatabaseReference {
        return mainDataBaseRef.child(FIR_CHILD_USERS)
    }
    var UsersFacebookRef: DatabaseReference {
        return mainDataBaseRef.child(FIR_CHILD_USERS).child("Facebook")
    }
    var UsersGoogleRef: DatabaseReference {
        return mainDataBaseRef.child(FIR_CHILD_USERS).child("Google")
    }
    var UsersEmailRef: DatabaseReference {
        return mainDataBaseRef.child(FIR_CHILD_USERS).child("Email")
    }
    
    
    
    var activeUserNameRef: DatabaseReference {
        return mainDataBaseRef.child("active_usernames")
    }
    
    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://cracc-c6f5f.appspot.com/")
    }
    
    var VideoStorageRef: StorageReference {
        return mainStorageRef.child("Video_Introduction")
    }
    
    var AvatarStorageRef: StorageReference {
        return mainStorageRef.child("Avatar")
    }
    var ChatImageStorageRef: StorageReference {
        return mainStorageRef.child("Chat Image")
    }
    
    
    
    func saveUser(_ uid: String) {
        mainDataBaseRef.child(FIR_CHILD_USERS).child(uid).child("User")
        
    }
    
    let connectedRef = Database.database().reference(withPath: ".info/connected")
    
    
    
    
    
    
}
