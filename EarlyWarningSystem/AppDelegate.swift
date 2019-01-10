//
//  AppDelegate.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/22/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GoogleMaps
import GooglePlaces
import Crashlytics
import Fabric
import UserNotifications
import FirebaseMessaging

let GoogleKey = "AIzaSyBalj8ZxHob3n5A5os79NYnVyIvxMQeeKY"
let placesKey = "AIzaSyBalj8ZxHob3n5A5os79NYnVyIvxMQeeKY"

let English = "en"
let French = "fr"



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    
    var location : CLLocation?
    var locationManager = CLLocationManager()
    var cityName: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GMSServices.provideAPIKey(GoogleKey)
        GMSPlacesClient.provideAPIKey(placesKey)
        
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        registerForPushNotifications()
        
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        Messaging.messaging().delegate = self
        
        if (Auth.auth().currentUser != nil) {
            let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            self.window?.rootViewController = ctrl
        }
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
//                if granted {
//                    print("Allowed")
//                    UIApplication.shared.registerForRemoteNotifications()
//                }else{
//                    print("Not Allowed")
//                }
                print("Permission granted: \(granted)")
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        let varAvgvalue = String(format: "%@", deviceToken as CVarArg)
        
        let  token = varAvgvalue.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
        
        print(token)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error.localizedDescription)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        Messaging.messaging().subscribe(toTopic: "Topic")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
    }


}


