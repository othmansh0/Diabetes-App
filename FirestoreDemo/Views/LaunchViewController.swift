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
            
    let defaults = UserDefaults.standard
    
    var activityView: UIActivityIndicatorView?


    override func viewDidLoad() {
        super.viewDidLoad()
        print("in launch screen")
        performSegue(withIdentifier: "tabSegue", sender: self)
        // Do any additional setup after loading the view.
        
      
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
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let PatientsViewController = storyboard.instantiateViewController(identifier: "PatientsNav")
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(PatientsViewController)
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
       
        
        
        let doctorID = defaults.string(forKey: "doctorID")
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
                    print("\(document.documentID) => \(document.data())")
                    let dataDescription = document.data()
                    //Patients.sharedInstance.patientsID.append(document.documentID)
                   // Patients.sharedInstance.names.append(dataDescription["Name"] as? String  ?? "no name")
                   
                    
                    tempPatient.userName = dataDescription["Name"] as? String  ?? "no name"
                    tempPatient.diabetesType = dataDescription["DiabetesType"] as? String  ?? "no diabetes type"
                    tempPatient.height = dataDescription["Height"] as? String  ?? "no height"
                    tempPatient.weight = dataDescription["Weight"] as? String  ?? "no weight"
                    tempPatient.birthdate = dataDescription["birthDate"] as? String  ?? "no birthdate"
                    tempPatient.docID = dataDescription["doctorID"] as? String  ?? "no doctor ID"
                    tempPatient.nationalID = dataDescription["nationalID"] as? String  ?? "no national ID"
                    Patients.sharedInstance.allPatients[document.documentID] = tempPatient // append pateint object to allPatients dictionary
                    
                   
                    
                    
                    //start another query to get all weeks readings
                    let weeks = self.db.collection("doctors").document(doctorID!).collection("patients").document(document.documentID).collection("weeks")

                    weeks.getDocuments { querySnapshot2, error in
                     
                            if let error = error {
                                print("error getting patients")
                                self.alert(message: "error getting patients")
                                completionHandler(.failure(.badURL))
                                return
                            }
                            
                            else {
                                //iterating over patients collection getting their names and IDs
                                for document in querySnapshot2!.documents {
                      
                                    print("weeks are r => \(document.data())")
                                    let dataDescription = document.data()
                                    //Patients.sharedInstance.patientsID.append(document.documentID)
                                   // Patients.sharedInstance.names.append(dataDescription["Name"] as? String  ?? "no name")
                                   
                                    
                                
                                    
                                    
                                   // self.fetchPersonalInfo(userID: document.documentID,getNameOnly: true)
                                }
                              
                              
                            }
                       
                    }
                    
                   // self.fetchPersonalInfo(userID: document.documentID,getNameOnly: true)
                }
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                completionHandler(.success(5))

                
               
              
            }
            
        }
    
    }
    
    
    
    
    public func fetchReadings(readingType: Int,doctorID:String,userID:String,weeksCount1:Int) -> [String]{
       //decides which array needs to be fetched from firestore
       var readingsType = ""
        var timesType = ""
        var deltaReadingsType = ""
       var readingsArray = [String]()
       var TimesArray = [String]()
        var deltaTimesArray = [String]()
        if readingType == 1 {
            readingsType = "afterReadings"
            timesType = "afterTimes"
            deltaReadingsType = "deltaAfterTimes"
           // print("tag is\(tag)")
        } else { readingsType = "beforeReadings"
            timesType = "beforeTimes"
            deltaReadingsType = "deltaBeforeTimes"
            //print("tag is\(tag)")
        }
        
        //get ref of patient
        
        DispatchQueue.main.async {
             let patient = self.db.collection("doctors").document(doctorID).collection("patients").document(userID).collection("weeks").document("week\(weeksCount1)")
           
            print(patient)
            
            patient.getDocument { document, error in
                if let document = document,document.exists {
                    guard let dataDescription = document.data() else {
                        print("------------------------------------------------------------------------------------")
                        print("error empty document")
                        print("------------------------------------------------------------------------------------")
                        return
                        
                    }
                    //print("------------------------------------------------------------------------------------")
                   // print("Document data: \(dataDescription)")
                    //print("------------------------------------------------------------------------------------")
                    
                    //fetch arrays from firebase
                    readingsArray = dataDescription[readingsType] as? [String] ?? ["error fetching array from firebase"]
        
                    TimesArray = dataDescription[timesType] as? [String] ?? ["error fetching array from firebase"]
                    
                   
                    if readingType == 1 {
                        Patient.sharedInstance.afterReadings = readingsArray.reversed()
                        
                        Patient.sharedInstance.afterTimes = TimesArray.reversed()
                        deltaTimesArray = dataDescription[deltaReadingsType] as? [String] ?? ["error fetching array from firebase"]
               
                        Patient.sharedInstance.deltaAfterTimes = deltaTimesArray.reversed()
                    } else {
                        Patient.sharedInstance.beforeReadings = readingsArray.reversed()
                        Patient.sharedInstance.beforeTimes = TimesArray.reversed()
                        deltaTimesArray = dataDescription[deltaReadingsType] as? [String] ?? ["error fetching array from firebase"]
                      
                        Patient.sharedInstance.deltaBeforeTimes = deltaTimesArray.reversed()
                    }
                    
                    
                  
           
                    print("------------------------------------------------------------------------------------")
                    print(readingsArray)
                    print("------------------------------------------------------------------------------------")
                    //return readingsArray
                } else {
                    print("error")
                    return
                }
            }
            
        }
        
        return readingsArray
    }

}
