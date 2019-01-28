//
//  AppDelegate.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Stripe
import Firebase
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    private let baseURLString: String = "https://obscure-cliffs-52108.herokuapp.com/"
    private let appleMerchantIdentifier: String = "merchant.campusConnectPay"
    private let publishableKey: String = Stripe_key

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        
        
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(googleMap_Key)
        STPPaymentConfiguration.shared().publishableKey = Stripe_key
        GMSPlacesClient.provideAPIKey(googlePlace_key)
        attemptRegisterForNotifications(application: application)
        
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            print("The app is launching for the first time. Setting UserDefaults...")
            
            do {
                try Auth.auth().signOut()
            } catch {
                
            }
            
            // Update the flag indicator
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize() // This forces the app to update userDefaults
            
            // Run code here for the first launch
            
        } else {
            print("The app has been launched before. Loading UserDefaults...")
            // Run code here for every other launch but the first
        }
 

        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for notifications:", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with FCM with token:", fcmToken)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content
        
        if userInfo.body == "Check it out now before it expires in 20 seconds." {
            
            
            notiCalled = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainVC")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    // listen for user notifications
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        
        
        
        
        
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        
    }
    
    
    
    private func attemptRegisterForNotifications(application: UIApplication) {
        print("Attempting to register APNS...")
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            // user notifications auth
            // all of this works for iOS 10+
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
                if let err = err {
                    print("Failed to request auth:", err)
                    return
                }
                
                if granted {
                    print("Auth granted.")
                } else {
                    print("Auth denied")
                }
            }
        } else {
            
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
            
        }
        
        
        
        application.registerForRemoteNotifications()
    }
 

    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if let incommingUrl = userActivity.webpageURL {
            
            
            guard let components = URLComponents(url: incommingUrl, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
                
                return false
            }
            
            
            for queryItem in queryItems {
                
                if queryItem.name == "code", queryItem.value != nil {
                    
                    authCode = queryItem.value!
                    
                    if authCode != "" {
                        
                        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "CodeProcess")), object: nil)
                        
                        
                        
                    }
                    
                    
                }
               
            }
            
        }
            
           
        
        return false
    }
    
  

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        guard Auth.auth().currentUser != nil else {
            
            return
            
        }
        
        
        DataService.instance.mainDataBaseRef.child("Status").child((Auth.auth().currentUser?.uid)!).setValue(["Online": 0])
        backgroundMode = true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        guard Auth.auth().currentUser != nil else {
            
            return
            
        }
        
        
        DataService.instance.mainDataBaseRef.child("Status").child((Auth.auth().currentUser?.uid)!).setValue(["Online": 0])
        
        backgroundMode = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        guard Auth.auth().currentUser != nil else {
            
            return
            
        }
        
        
        DataService.instance.mainDataBaseRef.child("Status").child((Auth.auth().currentUser?.uid)!).setValue(["Online": 0])
        
        backgroundMode = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        guard Auth.auth().currentUser != nil else {
         
            return
            
        }
        
        
        DataService.instance.mainDataBaseRef.child("Status").child((Auth.auth().currentUser?.uid)!).setValue(["Online": 1])
        
        backgroundMode = false
        
    }
    
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
   
    
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    override init() {
        super.init()
        
        // Stripe payment configuration
        STPPaymentConfiguration.shared().companyName = "Campus Connect LLC"
        
        if !publishableKey.isEmpty {
            STPPaymentConfiguration.shared().publishableKey = publishableKey
        }
        
        if !appleMerchantIdentifier.isEmpty {
            STPPaymentConfiguration.shared().appleMerchantIdentifier = appleMerchantIdentifier
        }

        // Main API client configuration
        MainAPIClient.shared.baseURLString = baseURLString
        
        
    }


}

