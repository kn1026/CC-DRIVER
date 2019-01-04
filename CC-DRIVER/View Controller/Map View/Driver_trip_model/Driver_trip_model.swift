//
//  Driver_trip_model.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/5/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
import CoreLocation

class Driver_trip_model {
    
  
    fileprivate var _Car_registration: String!
    fileprivate var _email: String!
    fileprivate var _phone: String!
    fileprivate var _Car_model: String!
    fileprivate var _birthday: String!
    fileprivate var _user_name: String!
    fileprivate var _UID: String!
    fileprivate var _Timestamp: Any!
    
    
    var Timestamp: Any! {
        get {
            if _Timestamp == nil {
                _Timestamp = 0
            }
            return _Timestamp
        }
    }
    
    var UID: String! {
        get {
            if _UID == nil {
                _UID = ""
            }
            return _UID
        }
        
    }
    
    var Car_registration: String! {
        get {
            if _Car_registration == nil {
                _Car_registration = ""
            }
            return _Car_registration
        }
        
    }
    var email: String! {
        get {
            if _email == nil {
                _email = ""
            }
            return _email
        }
        
    }
    var phone: String! {
        get {
            if _phone == nil {
                _phone = ""
            }
            return _phone
        }
        
    }
    var Car_model: String! {
        get {
            if _Car_model == nil {
                _Car_model = ""
            }
            return _Car_model
        }
        
    }
    var birthday: String! {
        get {
            if _birthday == nil {
                _birthday = ""
            }
            return _birthday
        }
        
    }
    var user_name: String! {
        get {
            if _user_name == nil {
                _user_name = ""
            }
            return _user_name
        }
        
    }
    
    
    init(postKey: String, Driver_trip_model: Dictionary<String, Any>) {
        
        
        if let user_name = Driver_trip_model["user_name"] as? String {
            self._user_name = user_name
            
        }
        
        if let Car_registration = Driver_trip_model["Car_registration"] as? String {
            self._Car_registration = Car_registration
            
        }
        
        if let email = Driver_trip_model["email"] as? String {
            self._email = email
            
        }
        
        if let phone = Driver_trip_model["phone"] as? String {
            self._phone = phone
            
        }
        
        if let Car_model = Driver_trip_model["Car_model"] as? String {
            self._Car_model = Car_model
            
        }
        
        if let birthday = Driver_trip_model["birthday"] as? String {
            self._birthday = birthday
            
        }
        
        if let Timestamp = Driver_trip_model["Timestamp"] {
            self._Timestamp = Timestamp
            
        }
        
        if let UID = Driver_trip_model["UID"] as? String {
            self._UID = UID
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
}
