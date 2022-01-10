//
//  SMSViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 10/25/21.
//

import UIKit

class SMSViewController: UIViewController, UISearchTextFieldDelegate {
    var accountType:Int!
    private var isBottomSheetShown = false
    
    @IBOutlet weak var codeTextField: CodeTextFieldViewController!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewLeadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)
        
        codeTextField.configure()
        codeTextField.didEnterLastDigit = { [weak self] code in
            print("code is\(code)")
            self?.checkSmsCode(check: code)
            //succeeded
        }
        codeTextField.delegate = self
        
        print(accountType)
        
        let defaults = UserDefaults.standard
        defaults.setValue(accountType, forKey: "accountType")
        //codeTextField.configure()
        
        //MARK: bottomsheet design
        bottomView.layer.cornerRadius = 30
        bottomView.clipsToBounds = true
        
        showBottomSheet()
        
        //makes UIView clickable
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        stretchBottomSheet()
    }
    
    
    
}

extension SMSViewController {
    //checks sms code
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
    
    
    //MARK: Bottom Sheet Animation (NEDINE)
    public func showBottomSheet(){
        if (isBottomSheetShown) {
            //default Bottom sheet
            UIView.animate(withDuration: 0.3) {
                self.bottomViewHeightConstraint.constant = 400
                // update view layout immediately
                self.view.layoutIfNeeded()
            } completion: { status in
                self.isBottomSheetShown = false
            }
        }
        
    }
    
    
    public func stretchBottomSheet(){
        UIView.animate(withDuration: 0.3) {
            self.bottomViewHeightConstraint.constant = 620
            // update view layout immediately
            self.view.layoutIfNeeded()
        } completion: { status in
            self.isBottomSheetShown = true
            
            //bouncing animation when card is shown
            UIView.animate(withDuration: 0.3) {
                self.bottomViewHeightConstraint.constant = 600
                
                self.view.layoutIfNeeded()
            } completion: { status in
                
            }
        
        }
    }
    
    @objc func dismissBottomSheet() {
        //return to min height
        showBottomSheet()
        //removes focus of phoneField
        codeTextField.resignFirstResponder()
    }
    
}
