//
//  PatientRegisterationViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 2/4/22.
//

import Firebase
import UIKit

class PatientRegisterationViewController: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var ageField: UITextField!
    @IBOutlet var doctorID: UITextField!
    @IBOutlet weak var diabetesType: UISegmentedControl!
    @IBOutlet weak var patientHeight: UITextField!
    @IBOutlet weak var patientWeight: UITextField!
    @IBOutlet weak var fastedReading: UITextField!
    @IBOutlet weak var unfastedReading: UITextField!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)

    }

    @IBAction func submitPressed(_ sender: UIButton) {
        
        if let Patientname = nameField.text,let pateintAge = ageField.text, let doctorID  = doctorID.text, let patientHeight = patientHeight.text, let patientWeight = patientWeight.text,let diabetesType = diabetesType.titleForSegment(at: diabetesType.selectedSegmentIndex), let fastedReading = fastedReading.text, let unfastedReading = unfastedReading.text{
            print(diabetesType)
            
            
            
            let defualts = UserDefaults.standard
            defualts.set(doctorID, forKey: "doctorID")
            
            
            
            let newPatient = db.collection("doctors").document(doctorID).collection("patients").document(Auth.auth().currentUser!.uid)
            newPatient.setData(["Name":Patientname,"Age":pateintAge,"Height":patientHeight,"Weight":patientWeight,"DiabetesType":diabetesType,"ID":newPatient.documentID,"beforeReadings":[],"afterReadings":[]])
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                // This is to get the SceneDelegate object from your view controller
                // then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "Patient") as? PatientViewController {
//                navigationController?.pushViewController(tabBarController!, animated: true)
//                navigationController?.pushViewController(vc, animated: true)
//            }
        
        }
       
        
        
    }
    
}
