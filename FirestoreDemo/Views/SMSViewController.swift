//
//  SMSViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 10/25/21.
//

import UIKit

class SMSViewController: UIViewController, UISearchTextFieldDelegate {
    @IBOutlet var codeField: UITextField!
    @IBOutlet weak var codeTextField: CodeTextFieldViewController!
    @IBOutlet weak var smsRectangle: UIImageView!
    var accountType:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)
        codeTextField.configure()
        codeTextField.didEnterLastDigit = { [weak self] code in
            print("code is\(code)")
            self?.checkSmsCode(check: code)
            //succeeded
        }
     
        print(accountType)
        codeTextField.delegate = self
        let defaults = UserDefaults.standard
        defaults.setValue(accountType, forKey: "accountType")
        //codeTextField.configure()
    }
    
 
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        textField.resignFirstResponder()
//        if let code = codeField.text {
//            AuthManager.shared.verifyCode(smsCode: code) {[weak self] (success) in
//                guard success else {
//
//                    return }
//                if self?.accountType == 0 {
//                    if let vc = self?.storyboard?.instantiateViewController(identifier: "Doctor") as? DoctorViewController {
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                    }
//                } else {
//                    if let vc = self?.storyboard?.instantiateViewController(identifier: "Patient") as? PatientViewController {
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//
//
//            }
//        }
//
//        return true
//    }

    private func checkSmsCode(check code:String) {
    
            AuthManager.shared.verifyCode(smsCode: code) {[weak self] (success) in
                guard success else {
                  
                    return }
                if self?.accountType == 0 {
                    if let vc = self?.storyboard?.instantiateViewController(identifier: "Doctor") as? DoctorViewController {
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    if let vc = self?.storyboard?.instantiateViewController(identifier: "Patient") as? PatientViewController {
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
              
                
            }
        
    }
    
    
}
