//
//  Rider_trip_model.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/5/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
import CoreLocation

/*
 
 ["Trip_key": -L9MJ9iF451Mmz7TYqjc, "PickUp_Lat": 43.1341231, "Destination_Lat": 43.0907205, "pickUp_name": khoi nguyen, "destinationAddress": 1801 Woodbury Ave, Portsmouth, NH 03801, USA, "price": 10.5, "chargedCardID": card_1CDShzJipU4QHqNkLLQovWlr, "Phone": +16032853880, "Timestamp": 1522957069259, "Destination_Lon": -70.79029079999999, "capturedKey": ch_1CDdu4JipU4QHqNkDzuET7fu, "pickUpEmail": kn1026@wildcats.unh.edu, "PickUp_Lon": -70.93496619999999, "pickUpAddress": 33 Academic Way, Durham, NH 03824, USA]
 
 
 */


class Rider_trip_model {
    
    
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
    
    
    
    
    
    
    init(postKey: String, Rider_trip_model: Dictionary<String, Any>) {
        
        
        if let Trip_key = Rider_trip_model["Trip_key"] as? String {
            self._Trip_key = Trip_key
            
        }
        
        if let PickUp_Lat = Rider_trip_model["PickUp_Lat"] as? CLLocationDegrees {
            self._PickUp_Lat = PickUp_Lat
            
        }
        
        if let Destination_Lat = Rider_trip_model["Destination_Lat"] as? CLLocationDegrees {
            self._Destination_Lat = Destination_Lat
            
        }
        
        if let pickUp_name = Rider_trip_model["pickUp_name"] as? String {
            self._pickUp_name = pickUp_name
            
        }
        
        if let destinationAddress = Rider_trip_model["destinationAddress"] as? String {
            self._destinationAddress = destinationAddress
            
        }
        
        if let price = Rider_trip_model["price"] as? Double {
            self._price = price
            
        }
        
        if let chargedCardID = Rider_trip_model["chargedCardID"] as? String {
            self._chargedCardID = chargedCardID
            
        }
        
        if let PickUp_Phone = Rider_trip_model["PickUp_Phone"] as? String {
            self._PickUp_Phone = PickUp_Phone
            
        }
        
        if let Destination_Lon = Rider_trip_model["Destination_Lon"] as? CLLocationDegrees {
            self._Destination_Lon = Destination_Lon
            
        }
        
        if let capturedKey = Rider_trip_model["capturedKey"] as? String {
            self._capturedKey = capturedKey
            
        }
        
        if let pickUpEmail = Rider_trip_model["pickUpEmail"] as? String {
            self._pickUpEmail = pickUpEmail
            
        }
        
        if let PickUp_Lon = Rider_trip_model["PickUp_Lon"] as? CLLocationDegrees {
            self._PickUp_Lon = PickUp_Lon
            
        }
        
        if let pickUpAddress = Rider_trip_model["pickUpAddress"] as? String {
            self._pickUpAddress = pickUpAddress
            
        }
        
        if let Trip_key = Rider_trip_model["Trip_key"] as? String {
            self._Trip_key = Trip_key
            
        }
        
      
        if let Timestamp = Rider_trip_model["Timestamp"] {
            self._Timestamp = Timestamp
            
        }
       
        
        if let distance = Rider_trip_model["distance"] as? String {
            self._distance = distance
            
        }
        
        if let rider_UID = Rider_trip_model["rider_UID"] as? String {
            self._rider_UID = rider_UID
            
        }
        

        
    }
    
    
}
