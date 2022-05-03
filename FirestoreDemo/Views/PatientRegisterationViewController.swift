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
    @IBOutlet var nationalIDField: UITextField!
    @IBOutlet var doctorID: UITextField!
    @IBOutlet weak var diabetesType: UISegmentedControl!
    @IBOutlet weak var patientHeight: UITextField!
    @IBOutlet weak var patientWeight: UITextField!

    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)
        nameField.useUnderline()
        nationalIDField.useUnderline()
        doctorID.useUnderline()
        patientHeight.useUnderline()
        patientWeight.useUnderline()
        
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        
        if let Patientname = nameField.text,let pateintAge = nationalIDField.text, let doctorID  = doctorID.text, let patientHeight = patientHeight.text, let patientWeight = patientWeight.text,let diabetesType = diabetesType.titleForSegment(at: diabetesType.selectedSegmentIndex){
            print(diabetesType)
            
            
            
            let defualts = UserDefaults.standard
            defualts.set(doctorID, forKey: "doctorID")
            
            
            
            let newPatient = db.collection("doctors").document(doctorID).collection("patients").document(Auth.auth().currentUser!.uid)
            newPatient.setData(["Name":Patientname,"Age":pateintAge,"Height":patientHeight,"Weight":patientWeight,"DiabetesType":diabetesType,"ID":newPatient.documentID,"beforeReadings":[],"beforeTimes":[],"afterReadings":[],"afterTimes":[]])
            
            
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

extension UITextField {
    func useUnderline() {
        //create bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height-2, width: self.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor(red: 117/255, green: 121/255, blue: 122/255, alpha: 0.26).cgColor
        //remove borders
        self.borderStyle = .none
        //add bottom border only
        self.layer.addSublayer(bottomLine)
        
    }
}
