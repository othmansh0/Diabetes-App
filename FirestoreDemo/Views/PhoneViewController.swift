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

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewLeadingConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var bottomBtnConstraint: NSLayoutConstraint!
    
    @IBOutlet var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneField.delegate = self
        
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)
    
        //MARK: Phonefield design
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: phoneField.frame.height-2, width: phoneField.frame.width, height: 1)
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
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name:UIResponder.keyboardWillShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name:UIResponder.keyboardWillHideNotification , object: nil)
    
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
            self.bottomViewHeightConstraint.constant = 670
            // update view layout immediately
            self.view.layoutIfNeeded()
        } completion: { status in
            self.isBottomSheetShown = true
            
            //bouncing animation when card is shown
            UIView.animate(withDuration: 0.3) {
                self.bottomViewHeightConstraint.constant = 650
                
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
    
    //takes dynamic height of keyboard
    //and makes button just above keyboard with animation
    @objc func keyboardWillShowNotification(notification:Notification) {
        if let frame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
           
            
            
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomBtnConstraint.constant = height + 10
                self.view.layoutIfNeeded()
            })
            
        }
        
    
        
    }
    @objc func keyboardWillHideNotification(notification : Notification) {
        UIView.animate(withDuration: 0.7, animations: {
            self.bottomBtnConstraint.constant = 82
            self.view.layoutIfNeeded()
        })
    }

    
    
    
    
}


