//
//  Constant.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
import Cache
import UIKit
import CoreLocation



let State = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", " Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]


let Unidict = ["Plymouth State University": "@plymouth.edu",
            "University of New Hampshire": "@wildcats.unh.edu",
            "Keene State College": "@ksc.keene.edu",
    "University of Vermont": "@uvm.edu",
    "Champlain College": "@mymail.champlain.edu",
    "UMass Amherst": "@umass.edu",
    "Clark University": "@clarku.edu",
    "WPI": "@wpi.edu",
    "Holy Cross": "@g.holycross.edu",
    "Assumption": "@my.assumption.edu",
    "Worcester State University": "@worcester.edu",
    "University of Connecticut": "@uconn.edu",
    "University of Rhode Island": "@my.uri.edu", "Campus-connect-test": "@campusconnectonline.com"]


var authCode = ""


let uniList = ["Assumption", "Champlain College", "Clark University", "Holy Cross", "Keene State College", "Plymouth State University", "UMass Amherst", "University of Connecticut", "University of New Hampshire", "University of Rhode Island", "University of Vermont", "WPI", "Worcester State University", "Campus-connect-test"]


let googleMap_Key = "AIzaSyAAYuBDXTubo_qcayPX6og_MrWq9-iM_KE"
let googlePlace_key = "AIzaSyAAYuBDXTubo_qcayPX6og_MrWq9-iM_KE"
let Stripe_key = "pk_live_1AA3PY5adk3jGDL1Eo5Db3PZ"
var applicationKey = "fd466555-559c-447e-95a0-4cc5ffbf303c"
let stripe_test_key = "pk_test_9edrI9MoXrXoYp591KT93gxW"
let dpwd = "ooewiuroiweyuruwehrgwehfgdsjhf"
let driveSDKKeyString = "0pLsk6vn4prBdWE1LvQu8S95MEZqh3IV"
let client_id = "ca_DWkdLOAvNorIOTz9TNDMsOjGOVq94jbJ"

var createdPhone = ""
let Shadow_Gray: CGFloat = 120.0 / 255.0
let space = "   "
var testEmailed = ""
var placeName = ""
var pickUp_add_Name = ""
var trip_key_request = ""
var backgroundMode = false
typealias DownloadComplete = () -> ()

var userUID = ""
var stripeID = ""
var userType = ""
var placeID1 = ""
var placeID2 = ""

var notiCalled = false

var isSelected = false

var basePrice = ""
var finalPrice = ""
var finalDistance = ""

var defaultCardID = ""
var chargedCardID = ""
var chargedlast4Digit = ""
var chargedCardBrand = ""



var cardID = ""
var cardBrand = ""
var cardLast4Digits = ""



var defaultBrand = ""
var defaultcardLast4Digits = ""



var isCancelShow = false

var pickUpLocation = CLLocationCoordinate2D()
var DestinationLocation = CLLocationCoordinate2D()

var pickUpAddress = ""
var destinationAddress = ""

let diskConfig = DiskConfig(name: "Floppy")
let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

let InformationStorage = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)



var isShippingDone = false
var isCarRegistrationDone = false
var DriverLics = false
var LicsPlate = false
var photoOfCar = false
var socialSecurity = false


var socialSecurityImg: UIImage?
var LicPlateImg: UIImage?
var DriverLicImg: UIImage?
var CarRegistImg: UIImage?
var Car1Photo: UIImage?
var Car2Photo: UIImage?


var Selectedadd1Txt = ""
var Selectedadd2Txt = ""
var SelectedCityTxt = ""
var SelectedStateTxt = ""
var SelectedzipcodeTxt = ""


func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

func timeAgoSinceDate(_ date:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = Date()
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(String(describing: components.year)) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hrs ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hr ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) mins ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 min ago"
        } else {
            return "A min ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!)s"
    } else {
        return "Just now"
    }
    
}


func delay(_ seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}
