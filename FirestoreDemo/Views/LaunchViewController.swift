//
//  LaunchViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/16/22.
//

import UIKit
import Firebase
class LaunchViewController: UIViewController {
    let db = Firestore.firestore()
                
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("in launch screen")
        performSegue(withIdentifier: "tabSegue", sender: self)
        // Do any additional setup after loading the view.
        
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        fetchPersonalInfo()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func fetchPersonalInfo()  {
       
        let patient = self.db.collection("doctors").document(Patient.sharedInstance.doctorID).collection("patients").document(Auth.auth().currentUser!.uid)
        patient.getDocument { document, error in
            
            
            if let document = document,document.exists {
                guard let dataDescription = document.data() else {
                    print("------------------------------------------------------------------------------------")
                    print("error empty document")
                    print("------------------------------------------------------------------------------------")
                    return
                }
                
                Patient.sharedInstance.userName = dataDescription["Name"] as? String  ?? "no name"
                Patient.sharedInstance.diabetesType = dataDescription["DiabetesType"] as? String  ?? "no diabetes type"
                Patient.sharedInstance.height = dataDescription["Height"] as? String  ?? "no height"
                Patient.sharedInstance.weight = dataDescription["Weight"] as? String  ?? "no weight"
                Patient.sharedInstance.birthdate = dataDescription["birthDate"] as? String  ?? "no birthdate"
                Patient.sharedInstance.docID = dataDescription["doctorID"] as? String  ?? "no doctor ID"
                Patient.sharedInstance.nationalID = dataDescription["nationalID"] as? String  ?? "no national ID"
                print("my nama \(Patient.sharedInstance.userName) ")
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // your code here delayed by 0.5 seconds
                   let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController
//                    let k = homeViewController?.selectedViewController as? PatientViewController
//                    k?.userName = Patient.sharedInstance.userName
                    //homeViewController?.userName = Patient.sharedInstance.userName
                    

//                                self.view.window?.rootViewController = homeViewController
//                                self.view.window?.makeKeyAndVisible()
                    
                    if let navController = homeViewController!.viewControllers?[0] as? UINavigationController{
                      var childNavVC = navController.children.first as? PatientViewController
                        childNavVC?.userName = Patient.sharedInstance.userName
                        childNavVC?.diabetesType = Patient.sharedInstance.diabetesType
                        childNavVC?.height = Patient.sharedInstance.height
                        childNavVC?.weight = Patient.sharedInstance.weight
                        childNavVC?.birthdate = Patient.sharedInstance.birthdate
                        childNavVC?.docID = Patient.sharedInstance.docID
                        childNavVC?.nationalID = Patient.sharedInstance.nationalID
                        self.view.window?.rootViewController = homeViewController
                                                  self.view.window?.makeKeyAndVisible()
                        
                    }
                    
                
                }
              
        }
            
            
    }
    }

}
