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
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)

    }
    

    @IBAction func submitPressed(_ sender: UIButton) {
        let newPatient = db.collection("doctors").document(doctorID.text!).collection("patients").document(Auth.auth().currentUser!.uid)
        newPatient.setData(["name":"WE DID IT","ID":newPatient.documentID]) 
    }
    
}
