//
//  baseVC2.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/25/22.
// Doctor shared class

import Foundation
import Firebase
class Patients {
    static let sharedInstance = Patients()
    var names = [String]()
    var patientsID = [String]()
    let db = Firestore.firestore()
//user IDs => patient object
    var allPatients =  [String: Patient]()

    
    
    

}
