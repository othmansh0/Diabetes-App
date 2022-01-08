//
//  AuthManager.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 10/25/21.
//
//AuthManager handles authentication flow once the user inputs their phone number

import FirebaseAuth
import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    //Create an instance of auth
    //Gets the auth object for the default Firebase app
    private let auth = Auth.auth()
    
    private var verficationID: String?
    
    
    //Completion a call back whether or not the start auth flow has succeeded
    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
            //completion to be called the verification flow is finished.
            if let error = error {
                   print(error.localizedDescription)
                   return
                 }
            //1.Make sure we have a verficationID and error is nil
            guard let verificationID = verificationID else {
                completion(false)
                return
            }
            self?.verficationID = verificationID
            completion(true)
        }
    }
    
    
    //Completion a call back if they user has successfully signed in
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationID = verficationID else {
            completion(false)
            return
        }
        //create a credintial using verificationID and smsCode
        let credintial = PhoneAuthProvider.provider().credential( withVerificationID: verificationID, verificationCode: smsCode)
        
        auth.signIn(with: credintial) { (result,error) in
            guard result != nil, error == nil else {
                print(error)
                completion(false)
                return
            }
            completion(true)
            
        }
        
        
    }

}
