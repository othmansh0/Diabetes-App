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
    @IBOutlet var ageField: UITextField!
    @IBOutlet var readLabel: UILabel!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)

        
        addButton.layer.borderWidth = 2
        //get reference to database
        db.collection("doctors").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
            //check for error
            if error == nil {
                //check that this document exists
                if document != nil && document!.exists {
                    let documentData = document?.data()
                    self.readLabel.text = documentData?["ID"] as? String
                    
                }
            }
            
        }
        
    
        
    }
    

    @IBAction func buttonTapped(_ sender: UIButton) {
        print("add button tapped")
        if let name = nameField.text,let age = ageField.text {
           
            
            let doctorID = name[0...2] + String(Int.random(in: 0...1000))
            print(doctorID)
            //Way 3 add specific document ID
            let newDocument = db.collection("doctors").document("\(doctorID)")
            
               newDocument.setData(["Name": name, "Age": age, "ID": newDocument.documentID])

            
        }
       
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
