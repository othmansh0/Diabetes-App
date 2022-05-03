//
//  PatientRegisterationViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 2/4/22.
//

import Firebase
import UIKit

class PatientRegisterationViewController: UIViewController {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var nationalIDField: UITextField!
    @IBOutlet var doctorID: UITextField!
    @IBOutlet weak var diabetesType: UISegmentedControl!
    @IBOutlet weak var patientHeight: UITextField!
    @IBOutlet weak var patientWeight: UITextField!

    @IBOutlet var diabetesLabel: UILabel!
    @IBOutlet var birthdateLabel: UILabel!
    
    let db = Firestore.firestore()

    var diabetesBtnMenu = dropDownBtn()
    var daysBtnMenu = dropDownBtn()
    var monthsBtnMenu = dropDownBtn()
    var yearsBtnMenu = dropDownBtn()
    
    let lineColor = UIColor(red: 117/255, green: 121/255, blue: 122/255, alpha: 0.26)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)
        nameField.addBottomBorder(lineColor, height: 1)
        nameField.borderStyle = .none
        nationalIDField.addBottomBorder(lineColor, height: 1)
        nationalIDField.borderStyle = .none
        doctorID.addBottomBorder(lineColor, height: 1)
        doctorID.borderStyle = .none
        patientHeight.addBottomBorder(lineColor, height: 1)
        patientWeight.addBottomBorder(lineColor, height: 1)
        
        
        //Diabetes Menu
        diabetesBtnMenu = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        diabetesBtnMenu.translatesAutoresizingMaskIntoConstraints = false
        diabetesBtnMenu.setTitle(" سكري ١", for: .normal)
        //add arrow to button
        let downArrow = UIImage(named: "arrowDown")
        diabetesBtnMenu.setImage(downArrow, for: .normal)
        diabetesBtnMenu.imageView?.contentMode = .scaleAspectFit
        diabetesBtnMenu.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:280)
        //add bottom border
        diabetesBtnMenu.addBottomBorder(lineColor, height: 1)
        //colors and text alignment
        diabetesBtnMenu.backgroundColor = .white
        diabetesBtnMenu.setTitleColor(UIColor(red: 227/255, green: 228/255, blue: 228/255, alpha: 1), for: .normal)
        diabetesBtnMenu.contentHorizontalAlignment = .right
        //Add Button to the View Controller
        self.view.addSubview(diabetesBtnMenu)
        //diabetes button Constraints
        diabetesBtnMenu.topAnchor.constraint(equalTo: diabetesLabel.bottomAnchor, constant: 10).isActive = true
        diabetesBtnMenu.trailingAnchor.constraint(equalTo: diabetesLabel.trailingAnchor).isActive = true
        diabetesBtnMenu.leadingAnchor.constraint(equalTo: nationalIDField.leadingAnchor).isActive = true
        diabetesBtnMenu.widthAnchor.constraint(equalToConstant: nationalIDField.frame.width).isActive = true
        diabetesBtnMenu.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //tag to differeniate buttons and set size correctly
        daysBtnMenu.tag = 1
        //Set the drop down menu's options
        diabetesBtnMenu.dropView.dropDownOptions = ["سكري ١","سكري ٢","سكري ٣"]
        
        
        //Days Menu
        daysBtnMenu = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        daysBtnMenu.translatesAutoresizingMaskIntoConstraints = false
        daysBtnMenu.setTitle("اليوم ", for: .normal)
        //add arrow to button
        daysBtnMenu.setImage(downArrow, for: .normal)
        daysBtnMenu.imageView?.contentMode = .scaleAspectFit
        daysBtnMenu.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:140)
        //add bottom border
        daysBtnMenu.addBottomBorder(lineColor, height: 1)
        //colors and text alignment
        daysBtnMenu.backgroundColor = .white
        daysBtnMenu.setTitleColor(UIColor(red: 227/255, green: 228/255, blue: 228/255, alpha: 1), for: .normal)
        daysBtnMenu.contentHorizontalAlignment = .right
        //Add Button to the View Controller
        self.view.addSubview(daysBtnMenu)
        //days button Constraints
        daysBtnMenu.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor, constant: 5).isActive = true
        daysBtnMenu.trailingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor).isActive = true
        daysBtnMenu.leadingAnchor.constraint(equalTo: diabetesLabel.leadingAnchor,constant: 2).isActive = true
        daysBtnMenu.widthAnchor.constraint(equalToConstant: birthdateLabel.frame.width+2).isActive = true
        daysBtnMenu.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //Set the drop down menu's options
        for day in 1...31 {
            daysBtnMenu.dropView.dropDownOptions.append(" \(day)")
        }

        daysBtnMenu.tag = 2
        
        
        
        
        
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        
        if let Patientname = nameField.text,let pateintAge = nationalIDField.text, let doctorID  = doctorID.text, let patientHeight = patientHeight.text, let patientWeight = patientWeight.text,let diabetesType = diabetesType.titleForSegment(at: diabetesType.selectedSegmentIndex){
            print(diabetesType)
            
            
            
            let defualts = UserDefaults.standard
            defualts.set(doctorID, forKey: "doctorID")
            
            
            
            let newPatient = db.collection("doctors").document(doctorID).collection("patients").document(Auth.auth().currentUser!.uid)
            newPatient.setData(["Name":Patientname,"Age":pateintAge,"Height":patientHeight,"Weight":patientWeight,"DiabetesType":diabetesType,"ID":newPatient.documentID,"beforeReadings":[],"beforeTimes":[],"afterReadings":[],"afterTimes":[]])
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                // This is to get the SceneDelegate object from your view controller
                // then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
//            if let vc = storyboard?.instantiateViewController(withIdentifier: "Patient") as? PatientViewController {
//                navigationController?.pushViewController(tabBarController!, animated: true)
//                navigationController?.pushViewController(vc, animated: true)
//            }
        
        }
       
        
        
    }
    
}


protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

class dropDownBtn: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.setTitle(" \(string)", for: .normal)
        self.dismissDropDown()
        self.setTitleColor(.black, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        
        //calculate inset size depending on word length
        let titleLength = self.currentTitle?.count
        if self.tag == 1{
        self.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:CGFloat(titleLength!+(280-titleLength!)))
        }
        else {
            self.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:CGFloat(titleLength!+(160-titleLength!)))

        }
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        
       
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = UIColor.gray
        self.backgroundColor = UIColor.black
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.flashScrollIndicators()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.textAlignment = .right
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        cell.backgroundColor = UIColor(red: 227/255, green: 228/255, blue: 228/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}









extension UITextField {
    func useUnderline() {
        //create bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height-2, width: self.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor(red: 117/255, green: 121/255, blue: 122/255, alpha: 0.26).cgColor
        //remove borders
        self.borderStyle = .none
        //add bottom border only
        self.layer.addSublayer(bottomLine)
        
    }
}

extension UIView {
    func addBottomBorder(_ color: UIColor, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
                                                attribute: NSLayoutConstraint.Attribute.height,
            multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.leading,
            multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
            multiplier: 1, constant: 0))
    }


}
