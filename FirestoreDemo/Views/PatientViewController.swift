//
//  PatientViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 11/7/21.
//
import Firebase
import UIKit

class PatientViewController: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var ageField: UITextField!
    @IBOutlet var doctorID: UITextField!
    @IBOutlet weak var diabetesType: UISegmentedControl!
    @IBOutlet weak var patientHeight: UITextField!
    @IBOutlet weak var patientWeight: UITextField!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)

    }
    

    @IBAction func submitPressed(_ sender: UIButton) {
        
        if let Patientname = nameField.text,let pateintAge = ageField.text, let doctorID  = doctorID.text, let patientHeight = patientHeight.text, let patientWeight = patientWeight.text,let diabetesType = diabetesType.titleForSegment(at: diabetesType.selectedSegmentIndex){
            print(diabetesType)
            
            
            
            let newPatient = db.collection("doctors").document(doctorID).collection("patients").document(Auth.auth().currentUser!.uid)
            newPatient.setData(["Name":Patientname,"Age":pateintAge,"Height":patientHeight,"Weight":patientWeight,"DiabetesType":diabetesType,"ID":newPatient.documentID])
            
            
           
            
        }
        
        
       
    }
    
}
