//
//  searchModel.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/23/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
import CoreLocation


class searchModel {
    
    
    fileprivate var _PlaceName: String!
    fileprivate var _PlaceAddress: String!
    fileprivate var _PlaceID: String!
    fileprivate var _Coordinate: CLLocationCoordinate2D!
    

    var PlaceName: String! {
        get {
            if _PlaceName == nil {
                _PlaceName = ""
            }
            return _PlaceName
        }
        
    }
    
    var PlaceAddress: String! {
        get {
            if _PlaceAddress == nil {
                _PlaceAddress = ""
            }
            return _PlaceAddress
        }
        
    }
    
    var PlaceID: String! {
        get {
            if _PlaceID == nil {
                _PlaceID = ""
            }
            return _PlaceID
        }
        
    }
    
    var Coordinate: CLLocationCoordinate2D! {
        get {
            if _Coordinate == nil {
                _Coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            }
            return _Coordinate
        }
        
    }
    
    
    
    
    init(postKey: String, searchModel: Dictionary<String, Any>) {
        
        
        if let PlaceName = searchModel["PlaceName"] as? String {
            self._PlaceName = PlaceName
            
        }
        
        if let PlaceAddress = searchModel["PlaceAddress"] as? String {
            self._PlaceAddress = PlaceAddress
            
        }
        
        if let PlaceID = searchModel["PlaceID"] as? String {
            self._PlaceID = PlaceID
            
        }
        
        if let Coordinate = searchModel["Coordinate"] as? CLLocationCoordinate2D {
            self._Coordinate = Coordinate
            
        }
        
        
        
        
        
        
        
        
    }
    
    
}
