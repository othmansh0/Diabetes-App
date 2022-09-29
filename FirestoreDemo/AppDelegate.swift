//
//  AppDelegate.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 10/25/21.
//
import Firebase
import FirebaseAuth
import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var doctorID:String!
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        //set navigation bar buttons tint for whole app 
        UINavigationBar.appearance().tintColor = UIColor(red: 52/255, green: 91/255, blue: 99/255, alpha: 1)
      
        
        doctorID = UserDefaults.standard.string(forKey: "doctorID")
        Patient.sharedInstance.doctorID = doctorID
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            //if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            // signOut from Auth
            do {
                try Auth.auth().signOut()
            }catch {
                
            }
            // go to beginning of app
        } else {
            //go to where you want
        }
        
        
        
        
        
        return true
    }
    
    
    
    
    
   
    
    
    
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

