//
//  LocalNotification.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/9/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class LocalNotification: NSObject, UNUserNotificationCenterDelegate {
    
    class func registerForLocalNotification(on application:UIApplication) {
        if (UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
            let notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            notificationCategory.identifier = "NOTIFICATION_CATEGORY"
            
            //registerting for the notification.
            application.registerUserNotificationSettings(UIUserNotificationSettings(types:[.sound, .alert, .badge], categories: nil))
        }
    }
    
    class func dispatchlocalNotification(with title: String, body: String, userInfo: [AnyHashable: Any]? = nil) {
        
        let date  = NSDate(timeIntervalSinceNow: 1)
        
        if #available(iOS 10.0, *) {
            
            
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.categoryIdentifier = "Fechou"
            
            if let info = userInfo {
                content.userInfo = info
            }
            
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                            repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
            
        } else {
            
           
            
            let notification = UILocalNotification()
            notification.fireDate = Date()
            notification.alertTitle = title
            notification.alertBody = body
            
            if let info = userInfo {
                notification.userInfo = info
            }
            
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.presentLocalNotificationNow(notification)
            
        }
        
      
        
        print("WILL DISPATCH LOCAL NOTIFICATION AT ", date)
        
    }
}


