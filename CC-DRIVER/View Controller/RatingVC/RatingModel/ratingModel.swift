//
//  ratingModel.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/8/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation

class ratingModel {
    
    
    fileprivate var _Rate: Int!
    fileprivate var _Key: String!
    fileprivate var _Text: String!
    fileprivate var _Timestamp: Any!
    
    
    var Rate: Int! {
        get {
            if _Rate == nil {
                _Rate = 0
            }
            return _Rate
        }
        
    }
    var Key: String! {
        get {
            if _Key == nil {
                _Key = ""
            }
            return _Key
        }
        
    }
    var Text: String! {
        get {
            if _Text == nil {
                _Text = ""
            }
            return _Text
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
    
    
    init(postKey: String, Rating_model: Dictionary<String, Any>) {
        
        
        
        if let Rate = Rating_model["Rate"] as? Int {
            self._Rate = Rate
            
        }
        
        if let Text = Rating_model["Text"] as? String {
            self._Text = Text
            
        }
        
        if let Key = Rating_model["Key"] as? String {
            self._Key = Key
            
        }
        
        if let Timestamp = Rating_model["Timestamp"] {
            self._Timestamp = Timestamp
            
        }
        
        
        
        
    }
    
    
    
}
