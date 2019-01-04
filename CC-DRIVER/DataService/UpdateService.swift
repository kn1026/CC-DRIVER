//
//  UpdateService.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/2/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase
import GeoFire

class UpdateService {
    
    static var instance = UpdateService()
    
    func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        
        
        let geoFireUrl = DataService.instance.mainDataBaseRef.child("Rider_coordinator")
        let geofireRef = geoFireUrl
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        
        
        geoFire.setLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), forKey: userUID)

    }
    
    func updateDriverLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        
        let geoFireUrl = DataService.instance.mainDataBaseRef.child("Driver_coordinator")
        let geofireRef = geoFireUrl
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        
        
        geoFire.setLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), forKey: userUID)
        
    }
    
    
    func updateOnTripDriverLocation(withCoordinate coordinate: CLLocationCoordinate2D, key: String) {
        
        
        
        
        let url = DataService.instance.mainDataBaseRef.child("On_Trip_Driver_coordinator").child(userUID).child(key)
        
        url.setValue(["Lat": coordinate.latitude, "Lon": coordinate.longitude])
        
    }
    
    
    
    func createReleaseCharge(dict: Dictionary<String, AnyObject>, key: String) {
        
        DataService.instance.mainDataBaseRef.child("Release_request").child(key).setValue(dict)
        
    }
    
    
    func createTrip(dict: Dictionary<String, AnyObject>, key: String) {
        
    DataService.instance.mainDataBaseRef.child("Trip_request").child(userUID).child(key).setValue(dict)
        

    }
    
    func matchToDriver(dict: Dictionary<String, AnyObject>, driverUID: String, key: String) {
        
    DataService.instance.mainDataBaseRef.child("Pending_driver").child(driverUID).child(key).setValue(dict)
        
    }
    
    func ExpTrip(dict: Dictionary<String, AnyObject>) {
        
    DataService.instance.mainDataBaseRef.child("Exp_Trip_request").child(userUID).childByAutoId().setValue(dict)
        
    }
    
    func CompletedTrip(dict: Dictionary<String, AnyObject>) {
        
    DataService.instance.mainDataBaseRef.child("Completed_Trip_request").child(userUID).childByAutoId().setValue(dict)
        
    }
    
    func observeTrips(handler: @escaping(_ coordinateDict: Dictionary<String, AnyObject>?) -> Void) {
        
        
    }
    
    func updateTripsWithCoordinatesUponRequest() {
        
        
        
    }
    
    func acceptTrip(withPassengerKey passengerKey: String, forDriverKey driverKey: String) {
       
        
        
    }
    
    func cancelTrip(withPassengerKey passengerKey: String, forDriverKey driverKey: String?) {
        
        
        
    }
    
}
