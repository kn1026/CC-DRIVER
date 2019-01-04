//
//  HistoryModel.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/8/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
import CoreLocation

class HistoryModel {
    
    fileprivate var _Trip_key: String!
    fileprivate var _PickUp_Lat: CLLocationDegrees!
    fileprivate var _Destination_Lat: CLLocationDegrees!
    fileprivate var _pickUp_name: String!
    fileprivate var _destinationAddress: String!
    fileprivate var _price: Double!
    fileprivate var _chargedCardID: String!
    fileprivate var _PickUp_Phone: String!
    fileprivate var _Timestamp: Any!
    fileprivate var _Destination_Lon: CLLocationDegrees!
    fileprivate var _capturedKey: String!
    fileprivate var _pickUpEmail: String!
    fileprivate var _distance: String!
    fileprivate var _PickUp_Lon: CLLocationDegrees!
    fileprivate var _pickUpAddress: String!
    fileprivate var _rider_UID: String!
    fileprivate var _Car_registration: String!
    fileprivate var _email: String!
    fileprivate var _phone: String!
    fileprivate var _Car_model: String!
    fileprivate var _birthday: String!
    fileprivate var _user_name: String!
    fileprivate var _UID: String!
    fileprivate var _ChargeStatus: String!
    fileprivate var _Progess: String!
    fileprivate var _DestinationName: String!
    fileprivate var _pickUpName: String!
    fileprivate var _chargedlast4Digit: String!
    fileprivate var _chargedCardBrand: String!
    
    
    
    
    
    var pickUpName: String! {
        get {
            if _pickUpName == nil {
                _pickUpName = ""
            }
            return _pickUpName
        }
        
    }
    
    var chargedlast4Digit: String! {
        get {
            if _chargedlast4Digit == nil {
                _chargedlast4Digit = ""
            }
            return _chargedlast4Digit
        }
        
    }
    
   
    
    var chargedCardBrand: String! {
        get {
            if _chargedCardBrand == nil {
                _chargedCardBrand = ""
            }
            return _chargedCardBrand
        }
        
    }
    
    var DestinationName: String! {
        get {
            if _DestinationName == nil {
                _DestinationName = ""
            }
            return _DestinationName
        }
        
    }
    
    var ChargeStatus: String! {
        get {
            if _ChargeStatus == nil {
                _ChargeStatus = ""
            }
            return _ChargeStatus
        }
        
    }
    
    var Progess: String! {
        get {
            if _Progess == nil {
                _Progess = ""
            }
            return _Progess
        }
        
    }
    
    var Timestamp: Any! {
        get {
            if _Timestamp == nil {
                _Timestamp = 0
            }
            return _Timestamp
        }
    }
    
    var distance: String! {
        get {
            if _distance == nil {
                _distance = ""
            }
            return _distance
        }
        
    }
    
    var rider_UID: String! {
        get {
            if _rider_UID == nil {
                _rider_UID = ""
            }
            return _rider_UID
        }
        
    }
    
    
    
    var Trip_key: String! {
        get {
            if _Trip_key == nil {
                _Trip_key = ""
            }
            return _Trip_key
        }
        
    }
    
    
    var PickUp_Lat: CLLocationDegrees! {
        get {
            if _PickUp_Lat == nil {
                _PickUp_Lat = 0
            }
            return _PickUp_Lat
        }
        
    }
    
    var Destination_Lat: CLLocationDegrees! {
        get {
            if _Destination_Lat == nil {
                _Destination_Lat = 0
            }
            return _Destination_Lat
        }
        
    }
    
    var pickUp_name: String! {
        get {
            if _pickUp_name == nil {
                _pickUp_name = ""
            }
            return _pickUp_name
        }
        
    }
    
    var destinationAddress: String! {
        get {
            if _destinationAddress == nil {
                _destinationAddress = ""
            }
            return _destinationAddress
        }
        
    }
    
    var price: Double! {
        get {
            if _price == nil {
                _price = 0.0
            }
            return _price
        }
        
    }
    
    var chargedCardID: String! {
        get {
            if _chargedCardID == nil {
                _chargedCardID = ""
            }
            return _chargedCardID
        }
        
    }
    
    var PickUp_Phone: String! {
        get {
            if _PickUp_Phone == nil {
                _PickUp_Phone = ""
            }
            return _PickUp_Phone
        }
        
    }
    
    var Destination_Lon: CLLocationDegrees! {
        get {
            if _Destination_Lon == nil {
                _Destination_Lon = 0
            }
            return _Destination_Lon
        }
        
    }
    
    var capturedKey: String! {
        get {
            if _capturedKey == nil {
                _capturedKey = ""
            }
            return _capturedKey
        }
        
    }
    
    var pickUpEmail: String! {
        get {
            if _pickUpEmail == nil {
                _pickUpEmail = ""
            }
            return _pickUpEmail
        }
        
    }
    
    var PickUp_Lon: CLLocationDegrees! {
        get {
            if _PickUp_Lon == nil {
                _PickUp_Lon = 0
            }
            return _PickUp_Lon
        }
        
    }
    
    var pickUpAddress: String! {
        get {
            if _pickUpAddress == nil {
                _pickUpAddress = ""
            }
            return _pickUpAddress
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
    
    init(postKey: String, History_trip_model: Dictionary<String, Any>) {
        
        
        if let Trip_key = History_trip_model["Trip_key"] as? String {
            self._Trip_key = Trip_key
            
        }
        
        if let PickUp_Lat = History_trip_model["PickUp_Lat"] as? CLLocationDegrees {
            self._PickUp_Lat = PickUp_Lat
            
        }
        
        if let Destination_Lat = History_trip_model["Destination_Lat"] as? CLLocationDegrees {
            self._Destination_Lat = Destination_Lat
            
        }
        
        if let pickUp_name = History_trip_model["pickUp_name"] as? String {
            self._pickUp_name = pickUp_name
            
        }
        
        if let destinationAddress = History_trip_model["destinationAddress"] as? String {
            self._destinationAddress = destinationAddress
            
        }
        
        if let price = History_trip_model["price"] as? Double {
            self._price = price
            
        }
        
        if let chargedCardID = History_trip_model["chargedCardID"] as? String {
            self._chargedCardID = chargedCardID
            
        }
        
        if let PickUp_Phone = History_trip_model["PickUp_Phone"] as? String {
            self._PickUp_Phone = PickUp_Phone
            
        }
        
        if let Destination_Lon = History_trip_model["Destination_Lon"] as? CLLocationDegrees {
            self._Destination_Lon = Destination_Lon
            
        }
        
        if let capturedKey = History_trip_model["capturedKey"] as? String {
            self._capturedKey = capturedKey
            
        }
        
        if let pickUpEmail = History_trip_model["pickUpEmail"] as? String {
            self._pickUpEmail = pickUpEmail
            
        }
        
        if let PickUp_Lon = History_trip_model["PickUp_Lon"] as? CLLocationDegrees {
            self._PickUp_Lon = PickUp_Lon
            
        }
        
        if let pickUpAddress = History_trip_model["pickUpAddress"] as? String {
            self._pickUpAddress = pickUpAddress
            
        }
        
        if let Trip_key = History_trip_model["Trip_key"] as? String {
            self._Trip_key = Trip_key
            
        }
        
        
        if let Timestamp = History_trip_model["Timestamp"] {
            self._Timestamp = Timestamp
            
        }
        
        
        if let distance = History_trip_model["distance"] as? String {
            self._distance = distance
            
        }
        
        if let rider_UID = History_trip_model["rider_UID"] as? String {
            self._rider_UID = rider_UID
            
        }
        
        if let user_name = History_trip_model["user_name"] as? String {
            self._user_name = user_name
            
        }
        
        if let Car_registration = History_trip_model["Car_registration"] as? String {
            self._Car_registration = Car_registration
            
        }
        
        if let email = History_trip_model["email"] as? String {
            self._email = email
            
        }
        
        if let phone = History_trip_model["phone"] as? String {
            self._phone = phone
            
        }
        
        if let Car_model = History_trip_model["Car_model"] as? String {
            self._Car_model = Car_model
            
        }
        
        if let birthday = History_trip_model["birthday"] as? String {
            self._birthday = birthday
            
        }
  
        if let UID = History_trip_model["UID"] as? String {
            self._UID = UID
            
        }
        
        if let ChargeStatus = History_trip_model["ChargeStatus"] as? String {
            self._ChargeStatus = ChargeStatus
            
        }
        
        if let Progess = History_trip_model["Progess"] as? String {
            self._Progess = Progess
            
        }
        
        if let DestinationName = History_trip_model["DestinationName"] as? String {
            self._DestinationName = DestinationName
            
        }
    
        if let pickUpName = History_trip_model["pickUpName"] as? String {
            self._pickUpName = pickUpName
            
        }
        
        if let chargedlast4Digit = History_trip_model["chargedlast4Digit"] as? String {
            self._chargedlast4Digit = chargedlast4Digit
            
        }
        
        if let chargedCardBrand = History_trip_model["chargedCardBrand"] as? String {
            self._chargedCardBrand = chargedCardBrand
            
        }
     
    }
    
    
}
