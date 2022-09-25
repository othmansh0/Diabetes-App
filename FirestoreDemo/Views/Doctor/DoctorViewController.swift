//
//  SingedViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 10/25/21.
//
import Firebase
import UIKit
import FirebaseFirestoreSwift
class DoctorViewController: UIViewController {
    @IBOutlet var addButton: UIButton!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var nationalIDField: UITextField!
   
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var doctorGovID: UITextField!
    @IBOutlet weak var btnBottomConstraint: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    var tempConstraint:Int!
    var typeVC = "register" //a flag to differentiate between registeration and edit mode
    
    var userName = ""
    var docGovID = ""
    var nationalID = ""
    
    
    let defaults = UserDefaults.standard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if typeVC == "register"{
            navigationController?.navigationBar.isHidden = true
           // segmentedDiabets.selectedSegmentIndex = 1
            
        } else {
           // tabBarController?.tabBar.layer.zPosition = -1
           

            addButton.imageView?.image = UIImage(named: "saveButton")
            nameField.text = userName
            nationalIDField.text = nationalID
           // birthDateField.text = birthdate
            //patientHeight.text = height
            //patientWeight.text = weight
            doctorGovID.text = docGovID
          

           
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("doctor id from defaults is \(defaults.string(forKey: "doctorID"))")
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)
        tempConstraint = Int(btnBottomConstraint.constant)
        cardView.layer.cornerRadius = 40
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
        subscribeToShowKeyboardNotifications()
        
        nameField.becomeFirstResponder()
       // addButton.layer.borderWidth = 2
        //get reference to database
        db.collection("doctors").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
            //check for error
            if error == nil {
                //check that this document exists
                if document != nil && document!.exists {
                    let documentData = document?.data()
                   // self.readLabel.text = documentData?["ID"] as? String
                    print(documentData?["ID"] as? String)
                }
            }
            
        }
        
        
    
        
    }
    

    @IBAction func buttonTapped(_ sender: UIButton) {
        print("add button tapped")
        if let name = nameField.text,let nationalID = nationalIDField.text,let doctorGovID = doctorGovID.text {
           
            if name.isEmpty || nationalID.isEmpty || doctorGovID.isEmpty {
                alert(message: "Please fill all fields", title: "Missing entry")
                return
            }
            let doctorID = name[0...2] + String(Int.random(in: 0...1000))
            
            defaults.setValue(doctorID, forKey: "doctorID")
            print(doctorID)
            //Way 3 add specific document ID
            let newDocument = db.collection("doctors").document("\(doctorID)")
            
            newDocument.setData(["Name": name, "NationalID": nationalID, "ID": newDocument.documentID,"DoctorGovID":doctorGovID])
//
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let PatientsViewController = storyboard.instantiateViewController(identifier: "PatientsNav")

//                 This is to get the SceneDelegate object from your view controller
//                 then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(PatientsViewController)
            
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "PatientsView") as? PatientsViewController {
//               // vc.modalPresentationStyle = .fullScreen
//                navigationController?.pushViewController(vc, animated: true)
//                present(navigationController!, animated: true, completion: nil)
//               // present(vc, animated: true)
//            }
        }
        
       
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
           let userInfo = notification.userInfo
        let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
           let keyboardHeight = keyboardSize.cgRectValue.height
        btnBottomConstraint.constant = 10 + keyboardHeight
        
        
        let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
       }

       @objc func keyboardWillHide(_ notification: Notification) {
           btnBottomConstraint.constant = CGFloat(tempConstraint!)
           let userInfo = notification.userInfo
           let animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
               UIView.animate(withDuration: animationDuration) {
                   self.view.layoutIfNeeded()
               }
       }

       func subscribeToShowKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: DoctorViewController.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: DoctorViewController.keyboardWillHideNotification, object: nil)
       }

       @objc func buttonAction() {
           //testTextField.resignFirstResponder()
       }
    
    @objc func dismissMyKeyboard(){
        //removes focus of phoneField
        //phoneField.resignFirstResponder()
        nameField.resignFirstResponder()
        nationalIDField.resignFirstResponder()
        doctorGovID.resignFirstResponder()
        //btnBottomConstraint.constant = tempConstraint.constant
        //diabetesBtnMenu.dismissDropDown()
    }
}





public extension String {
  subscript(value: Int) -> Character {
    self[index(at: value)]
  }
}

public extension String {
  subscript(value: NSRange) -> Substring {
    self[value.lowerBound..<value.upperBound]
  }
}

public extension String {
  subscript(value: CountableClosedRange<Int>) -> Substring {
    self[index(at: value.lowerBound)...index(at: value.upperBound)]
  }

  subscript(value: CountableRange<Int>) -> Substring {
    self[index(at: value.lowerBound)..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeUpTo<Int>) -> Substring {
    self[..<index(at: value.upperBound)]
  }

  subscript(value: PartialRangeThrough<Int>) -> Substring {
    self[...index(at: value.upperBound)]
  }

  subscript(value: PartialRangeFrom<Int>) -> Substring {
    self[index(at: value.lowerBound)...]
  }
}

private extension String {
  func index(at offset: Int) -> String.Index {
    index(startIndex, offsetBy: offset)
  }
}
