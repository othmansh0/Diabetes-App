//
//  SceneDelegate.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 10/25/21.
//
import FirebaseAuth
import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let db = Firestore.firestore()
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let window = UIWindow(frame: UIScreen.main.bounds)
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

//if not registered navigate to registeration form
        if Auth.auth().currentUser != nil {
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

            let defaults = UserDefaults.standard
            let accountType = defaults.integer(forKey: "accountType")
            if (accountType == 0) {
                
                print("i got called")
               // let viewController = storyboard.instantiateViewController(withIdentifier: "Doctor") as! DoctorViewController
                
                
                
                //------
//                let launchViewController = storyboard.instantiateViewController(identifier: "PatientsNav")
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(launchViewController)
//           window.rootViewController = launchViewController
                //-----------
                
                
                
                
                let launchViewController = storyboard.instantiateViewController(identifier: "launchView")
               
                                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(launchViewController)
                               window.rootViewController = launchViewController
                
                
            } else { // patient
                
             
                print("im here right before tab controller")
//
//
//                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
//
//                     (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
//                window.rootViewController = mainTabBarController
                
                let launchViewController = storyboard.instantiateViewController(identifier: "launchView")
               
                                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(launchViewController)
                               window.rootViewController = launchViewController
                
                
            }
                
           
//            let navigationController = UINavigationController.init(rootViewController: viewController)
            
        } else {//Home page
          
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

            let viewController = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                    let navigationController = UINavigationController.init(rootViewController: viewController)
            self.window?.rootViewController = navigationController
            
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            window.rootViewController = loginNavController
        }

        self.window?.makeKeyAndVisible()
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        // change the root view controller to your specific view controller
        window.rootViewController = vc
    }
    
    
    
    

}

