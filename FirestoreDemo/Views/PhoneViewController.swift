//
//  ViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 10/25/21.
//
import Firebase
import UIKit

class PhoneViewController: UIViewController, UITextFieldDelegate {
    var accountType:Int!
    private var isBottomSheetShown = false

    @IBOutlet var bottomView: UIView!
    
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewLeadingConstraint: NSLayoutConstraint!
   
    @IBOutlet var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneField.delegate = self
        
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)
    
        //MARK: Phonefield design
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: phoneField.frame.height - 2, width: phoneField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        phoneField.borderStyle = UITextField.BorderStyle.none
        phoneField.layer.addSublayer(bottomLine)
        // phoneField.keyboardType = .numberPad
        
        //MARK: bottomsheet design
        bottomView.layer.cornerRadius = 30
        bottomView.clipsToBounds = true
        
        showBottomSheet()
        
        //makes UIView clickable
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
        view.addGestureRecognizer(tap)
        
    }
    

    @IBAction func submitPressed(_ sender: UIButton) {
        if let text = phoneField.text {
            let number = "+962\(text)"
            AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
                guard success else {
                    
                    return }
            
                    if let vc = self?.storyboard?.instantiateViewController(identifier: "SMS") as? SMSViewController {
                        vc.accountType = self?.accountType
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
              
            }
        }
    }
    
  
    //Max length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 9
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    //open bottom sheet when phone field is clicked
    func textFieldDidBeginEditing(_ textField: UITextField) {
            //open bottom sheet
        stretchBottomSheet()
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
        phoneField.resignFirstResponder()
    }
    
}


