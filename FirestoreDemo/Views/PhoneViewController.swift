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
    @IBOutlet var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneField.delegate = self
        
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)
    
        //phoneField design
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: phoneField.frame.height - 2, width: phoneField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        phoneField.borderStyle = UITextField.BorderStyle.none
        phoneField.layer.addSublayer(bottomLine)
       // phoneField.keyboardType = .numberPad
    
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    
      
  
           
      
        
        if let text = textField.text {
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
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 9
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

