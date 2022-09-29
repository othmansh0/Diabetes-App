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
    var delta2 = [String]()
    let defaults = UserDefaults.standard
    var doctorID: String!
    var activityView: UIActivityIndicatorView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in launch screen")
        performSegue(withIdentifier: "tabSegue", sender: self)
        // Do any additional setup after loading the view.
        
        doctorID = defaults.string(forKey: "doctorID")
    }
    enum NetworkError: Error {
        case badURL
    }

    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let accountType = defaults.integer(forKey: "accountType")
        if accountType == 0 {
            //self.fetchPatientsInfo()
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              
                fetchPatientsInfo() { result in
                switch result {
                case .success(let count):
                   
                    
                    print("\(count) unread messages.")
                    print(Patients.sharedInstance.allPatients.count)
                    //call fetch weeks here iterate over all patients keys
                   
                    
                 
                     
                    //iterate over all users in docotr collection
                    for myUserID in Patients.sharedInstance.patientsID {
                        self.fetchWeeks(doctorID: self.doctorID, userID: myUserID) { result in
                            switch result {
                                
                            case .success(let weeks):
                                print("weeks array  is \(weeks)")
                                //iterating over all weeks for each user
                                for week in weeks {
                                    self.fetchReadings(doctorID: self.doctorID, userID:myUserID , week: week) { result in
                                        switch result {
                                        case .success(let tuple1):
                                            //print("tuple 1:\(tuple1.readings)")
                                           // Patients.sharedInstance.allPatients["rxJtmu839HZMEv7AdOtotHkQ7pD3"]?.dictData =
                                            //Patients.sharedInstance.allPatients["rxJtmu839HZMEv7AdOtotHkQ7pD3"]?.weeksData[week] = Patients.sharedInstance.allPatients["rxJtmu839HZMEv7AdOtotHkQ7pD3"]?.dictData
                                            
                                            //setting fetched data (dictData from fetchReadings) in weeksDict
                                            Patients.sharedInstance.allPatients[myUserID]?.setWeekData(week: week)
                                            
                                            print("shared instance \(Patients.sharedInstance.allPatients[myUserID]!.weeksData[week]!["afterReadings"])")
                                            //print("shared instance 2 \(Patients.sharedInstance.allPatients[myUserID]!.weeksData[week]!["beforeTimes"])")
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let PatientsViewController = storyboard.instantiateViewController(identifier: "PatientsNav")
                                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(PatientsViewController)
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                                
                                
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                                
                            }
                        }
                    }
                    
                    
                    
                    

                     
                   
                    
                    print("------------------------------------------------------------------------------------------------------------")

                    print("before going to next view we got weeks")
                    print("------------------------------------------------------------------------------------------------------------")
                    //call fetch readings for each patient
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            
        } else {
            print("patient")
            fetchPersonalInfo()
        }
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //print(Patients.sharedInstance.names[0])
        print("patients count in launch view is \(Patients.sharedInstance.names.count)")

    }
    
//    func fetchPatientsInfo()  {
//        let doctorID = defaults.string(forKey: "doctorID")
//        let doctor = self.db.collection("doctors").document(doctorID!).collection("patients")
//
//        doctor.getDocuments { querySnapshot, err in
//
//            if let err = err {
//                print("error getting patients")
//                self.alert(message: "error getting patients")
//            }
//
//            else {
//                for document in querySnapshot!.documents {//iterating over patients collection getting their names and IDs
//                    print("\(document.documentID) => \(document.data())")
//                    let dataDescription = document.data()
//                    Patients.sharedInstance.patientsID.append(document.documentID)
//                    Patients.sharedInstance.names.append(dataDescription["Name"] as? String  ?? "no name")
//                   // self.fetchPersonalInfo(userID: document.documentID,getNameOnly: true)
//                }
//            }
//
//        }
//    }
    
    
    
    
    func fetchPersonalInfo(userID:String = Auth.auth().currentUser!.uid)  {
      
        let patient = self.db.collection("doctors").document(Patient.sharedInstance.doctorID).collection("patients").document(userID)
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
    
    
    
    
    //MARK: Doctor fetching functions
    
    func fetchPatientsInfo(completionHandler: @escaping (Result<Int, NetworkError>) -> Void)  {
       
        let doctor = self.db.collection("doctors").document(doctorID!).collection("patients")
    
        doctor.getDocuments { querySnapshot, err in
            
            if let err = err {
                print("error getting patients")
                self.alert(message: "error getting patients")
                completionHandler(.failure(.badURL))
                return
            }
            
            else {
                
                let child = SpinnerViewController()

                   // add the spinner view controller
                self.addChild(child)
                child.view.frame = self.view.frame
                self.view.addSubview(child.view)
               child.didMove(toParent: self)
                
                //iterating over patients collection getting their names and IDs
                for document in querySnapshot!.documents {
                    let tempPatient = Patient()
                   // self.myUserID = document.documentID
                    print("------------------------------------------------------------------------------------------------------------")

                    print("\(document.documentID) => \(document.data())")
                    print("------------------------------------------------------------------------------------------------------------")

                    let dataDescription = document.data()
                    Patients.sharedInstance.patientsID.append(document.documentID)
                    Patients.sharedInstance.names.append(dataDescription["Name"] as? String  ?? "no name")
                   
                    
                    tempPatient.userName = dataDescription["Name"] as? String  ?? "no name"
                    tempPatient.diabetesType = dataDescription["DiabetesType"] as? String  ?? "no diabetes type"
                    tempPatient.height = dataDescription["Height"] as? String  ?? "no height"
                    tempPatient.weight = dataDescription["Weight"] as? String  ?? "no weight"
                    tempPatient.birthdate = dataDescription["birthDate"] as? String  ?? "no birthdate"
                    tempPatient.docID = dataDescription["doctorID"] as? String  ?? "no doctor ID"
                    tempPatient.nationalID = dataDescription["nationalID"] as? String  ?? "no national ID"
                    tempPatient.history = dataDescription["History"] as? String  ?? ""
                    tempPatient.isVisited = dataDescription["isVisited"] as? Bool ?? false
                    Patients.sharedInstance.allPatients[document.documentID] = tempPatient // append pateint object to allPatients dictionary
                    
                   
                        print("fucky must be after week1")
                    
                   // self.fetchPersonalInfo(userID: document.documentID,getNameOnly: true)
                }
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                print("step 1")
                completionHandler(.success(5))

                
               
              
            }
            
        }
    
    }
    
//
    
    func fetchWeeks(doctorID:String,userID:String,completionHandler: @escaping (Result<[String], NetworkError>) -> Void)  {
       
        
        var weeks = [String]()
       
        let doctor = self.db.collection("doctors").document(doctorID).collection("patients").document(userID).collection("weeks")
    
        doctor.getDocuments { querySnapshot, err in
            
            if let err = err {
                print("error getting patients")
                self.alert(message: "error getting patients")
                completionHandler(.failure(.badURL))
                return
            }
            
            else {
                
                let child = SpinnerViewController()

                   // add the spinner view controller
                self.addChild(child)
                child.view.frame = self.view.frame
                self.view.addSubview(child.view)
               child.didMove(toParent: self)
                
                //iterating over patients collection getting their names and IDs
                for document in querySnapshot!.documents {
                    print("desc is \(document.documentID)")
                    weeks.append(document.documentID)
                    //arr.append(doc?.documentID ?? "no week")
              
                }
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                print("step 2")
                completionHandler(.success(weeks))

            }
            
        }
       
    }
    //(readings: [String], readingsTimes: [String],delta:[String])
    
    //fetch readings and stores them in dictData in patient object
    public func fetchReadings(doctorID:String,userID:String,week:String,completionHandler: @escaping (Result<Int,NetworkError>) -> Void)  {

        
       var afterReadings = [String]()
       var afterTimes = [String]()
        var deltaAfterTimes = [String]()
        
        var beforeReadings = [String]()
        var beforeTimes = [String]()
         var deltaBeforeTimes = [String]()
        
        //get ref of patient
  let patient = self.db.collection("doctors").document(doctorID).collection("patients").document(userID).collection("weeks").document(week)

            print(patient)

            patient.getDocument { document, error in
                if let document = document,document.exists {
                    guard let dataDescription = document.data() else {
                        print("------------------------------------------------------------------------------------")
                        print("error empty document")
                        print("------------------------------------------------------------------------------------")
                        completionHandler(.failure(.badURL))
                        return

                    }
                

                    //fetch arrays from firebase
                    afterReadings = dataDescription["afterReadings"] as? [String] ?? ["error fetching array from firebase"]
                    afterTimes = dataDescription["afterTimes"] as? [String] ?? ["error fetching array from firebase"]
                    deltaAfterTimes = dataDescription["deltaAfterTimes"] as? [String] ?? ["error fetching array from firebase"]
                    
                    beforeReadings = dataDescription["beforeReadings"] as? [String] ?? ["error fetching array from firebase"]
                    beforeTimes = dataDescription["beforeTimes"] as? [String] ?? ["error fetching array from firebase"]
                    deltaBeforeTimes = dataDescription["deltaBeforeTimes"] as? [String] ?? ["error fetching array from firebase"]
                  
                    Patients.sharedInstance.allPatients[userID]?.dictData["afterReadings"] = afterReadings
                    Patients.sharedInstance.allPatients[userID]?.dictData["afterTimes"] = afterTimes
                    Patients.sharedInstance.allPatients[userID]?.dictData["deltaAfterTimes"] = deltaAfterTimes
                    
                    Patients.sharedInstance.allPatients[userID]?.dictData["beforeReadings"] = beforeReadings
                    Patients.sharedInstance.allPatients[userID]?.dictData["beforeTimes"] = beforeTimes
                    Patients.sharedInstance.allPatients[userID]?.dictData["deltaBeforeTimes"] = deltaBeforeTimes
                    
                    print("step 3")
                    
                    completionHandler(.success(6))
} else {
                    print("error")
                    return
                }
            }

    }

}
