//
//  PatientRegisterationViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 2/4/22.
//

import Firebase
import UIKit
import MASegmentedControl

class PatientRegisterationViewController: UIViewController,UITextFieldDelegate,CustomSegmentedControlDelegate {
    func change(to index: Int) {
        print("index changed")
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var nationalIDField: UITextField!
    @IBOutlet var doctorIDField: UITextField!
    @IBOutlet weak var patientHeight: UITextField!
    @IBOutlet weak var patientWeight: UITextField!
    @IBOutlet var cardView: UIView!
    
   @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var diabetesLabel: UILabel!
    @IBOutlet var birthdateLabel: UILabel!
   
    @IBOutlet weak var submitBtn: UIButton!
    
    var userName = ""
    var diabetesType = ""
    var height = ""
    var weight = ""
    var birthdate = ""
    var docID = ""
    var nationalID = ""
    
    
    let diabetesOptions = ["سكري ٣","سكري ٢","سكري ١"]
  
    var typeVC = "register" //a flag to differentiate between registeration and edit mode
    
    //lab counter stored in user defaults to count number of labs user imported
    var labsCounter = 0
    var weeksCount = 1
    var openedDate = ""
    
    let defaults = UserDefaults.standard
    

    
    @IBOutlet weak var segmentedDiabets: MASegmentedControl! {
        didSet {
            
            //Set this booleans to adapt control
            segmentedDiabets.itemsWithText = true
            segmentedDiabets.fillEqually = true
            segmentedDiabets.bottomLineThumbView = true
            segmentedDiabets.titlesFont = UIFont(name: "TimesNewRomanPS-BoldMT", size: 20)
            
            segmentedDiabets.setSegmentedWith(items: diabetesOptions)
            segmentedDiabets.padding = 2
            segmentedDiabets.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            segmentedDiabets.selectedTextColor = UIColor(red: 188/255, green: 209/255, blue: 204/255, alpha: 1)
            segmentedDiabets.thumbViewColor =  UIColor(red: 188/255, green: 209/255, blue: 204/255, alpha: 1)
            
        }
    }
   
    
    
    
    
    
    
    
    
    @IBOutlet var birthDateField: UITextField!
    
    let db = Firestore.firestore()

    
    var datePicker = UIDatePicker()
   // var diabetesBtnMenu = dropDownBtn()
    let lineColor = UIColor(red: 117/255, green: 121/255, blue: 122/255, alpha: 0.26)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   

        
        if typeVC == "register"{
            navigationController?.navigationBar.isHidden = true
           // segmentedDiabets.selectedSegmentIndex = 1
            
        } else {
            tabBarController?.tabBar.layer.zPosition = -1
           

            submitBtn.imageView?.image = UIImage(named: "saveButton")
            nameField.text = userName
            nationalIDField.text = nationalID
            birthDateField.text = birthdate
            patientHeight.text = height
            patientWeight.text = weight
            doctorIDField.text = docID
            if(diabetesType == diabetesOptions[0]) {
                segmentedDiabets.selectedSegmentIndex = 0

            }
            else if(diabetesType == diabetesOptions[1]){
                segmentedDiabets.selectedSegmentIndex = 1
            }
            else{
                segmentedDiabets.selectedSegmentIndex = 2
            }
//            segmentedDiabets.selectedSegmentIndex = 0
////
//            print("fuck dia \(diabetesOptions[0])")
            //segmentedDiabets.selectedSegmentIndex = 2
           
        }
       
       
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.layer.zPosition = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setBackgroundImage("greenBG", contentMode: .scaleAspectFit)
        
        defaults.set(labsCounter, forKey: "labsCounter")
        defaults.set(weeksCount, forKey: "weeksCount")
      // scrollView.touch
       // self.myScrollview.panGestureRecognizer.delaysTouchesBegan = true

       
        
        
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        openedDate = formatter.string(from: now)
        defaults.set(openedDate, forKey: "openedDate")
        print("opened date is \(openedDate)")
        
        
        //Showing bottomBorder only of textFields
        nameField.addBottomBorder(lineColor, height: 1)
        nameField.borderStyle = .none
        nationalIDField.addBottomBorder(lineColor, height: 1)
        nationalIDField.borderStyle = .none
        doctorIDField.addBottomBorder(lineColor, height: 1)
        doctorIDField.borderStyle = .none
        birthDateField.addBottomBorder(lineColor, height: 1)
        birthDateField.borderStyle = .none
        birthDateField.textAlignment = .right
        //remove cursor
        birthDateField.tintColor = .clear
        
        patientHeight.borderStyle = .none
        patientWeight.borderStyle = .none
        patientHeight.addBottomBorder(lineColor, height: 1)
        patientWeight.addBottomBorder(lineColor, height: 1)
        
        
        cardView.layer.cornerRadius = 40
////        //MARK: Diabetes Menu
//        diabetesBtnMenu = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        diabetesBtnMenu.translatesAutoresizingMaskIntoConstraints = false
//        diabetesBtnMenu.setTitle(" سكري ١", for: .normal)
//        //add arrow to button
//        let downArrow = UIImage(named: "arrowDown")
//        diabetesBtnMenu.setImage(downArrow, for: .normal)
//        diabetesBtnMenu.imageView?.contentMode = .scaleAspectFit
//        diabetesBtnMenu.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:280)
//        //add bottom border
//        diabetesBtnMenu.addBottomBorder(lineColor, height: 1)
//        //colors and text alignment
//        diabetesBtnMenu.backgroundColor = .white
//        diabetesBtnMenu.setTitleColor(UIColor(red: 227/255, green: 228/255, blue: 228/255, alpha: 1), for: .normal)
//        diabetesBtnMenu.contentHorizontalAlignment = .right
//        //Add Button to the View Controller
//        self.view.addSubview(diabetesBtnMenu)
//
//        //diabetes button Constraints
//        diabetesBtnMenu.topAnchor.constraint(equalTo: diabetesLabel.bottomAnchor, constant: 10).isActive = true
//        diabetesBtnMenu.leadingAnchor.constraint(equalTo: nationalIDField.leadingAnchor).isActive = true
//        diabetesBtnMenu.widthAnchor.constraint(equalToConstant: nameField.frame.width-23).isActive = true
//       // diabetesBtnMenu.widthAnchor.constraint(equalTo: nameField.widthAnchor).isActive = true
//
//        diabetesBtnMenu.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        //tag to differeniate buttons and set size correctly
//        //daysBtnMenu.tag = 1
//        //Set the drop down menu's options
//        diabetesBtnMenu.dropView.dropDownOptions = ["سكري ١","سكري ٢","سكري ٣"]
//       // diabetesBtnMenu.addTarget(self, action: #selector(buttonAction(_:)), for: .allEvents)

        
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .small)
      

        
        let calendarImage = UIImage(systemName: "calendar",withConfiguration: smallConfiguration)!
       
       
        
        
       // let graySmallConfig = smallConfiguration.applying(smallConfiguration)
        
        
        let grayCalImage = calendarImage.withTintColor(.gray, renderingMode: .alwaysOriginal)
        
        let imageView = UIImageView(image: grayCalImage)
        imageView.tintColor = .gray
        birthDateField.setIcon(imageView.image!,Int(birthDateField.frame.width*0.88))
        
        birthDateField.setRightPaddingPoints(birthDateField.frame.width*0.06)
        
        
        
//
//        //MARK: Days Menu
//        daysBtnMenu = dropDownBtn2.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        daysBtnMenu.translatesAutoresizingMaskIntoConstraints = false
//        daysBtnMenu.setTitle("اليوم ", for: .normal)
//
//        //add bottom border
//        daysBtnMenu.addBottomBorder(lineColor, height: 1)
//        //colors and text alignment
//        daysBtnMenu.backgroundColor = .white
//        daysBtnMenu.setTitleColor(UIColor(red: 227/255, green: 228/255, blue: 228/255, alpha: 1), for: .normal)
//        daysBtnMenu.contentHorizontalAlignment = .right
//        //Add Button to the View Controller
//        self.view.addSubview(daysBtnMenu)
//        //days button Constraints
//        daysBtnMenu.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor, constant: 5).isActive = true
//        daysBtnMenu.trailingAnchor.constraint(equalTo: birthdateLabel.trailingAnchor).isActive = true
//        daysBtnMenu.leadingAnchor.constraint(equalTo: diabetesLabel.leadingAnchor,constant: 2).isActive = true
//        //daysBtnMenu.widthAnchor.constraint(equalToConstant: birthdateLabel.frame.width+6).isActive = true
//
//
//        daysBtnMenu.widthAnchor.constraint(equalTo: nameField.widthAnchor, multiplier: 0.25, constant: 0).isActive = true
//
//
//        daysBtnMenu.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        //Set the drop down menu's options
//        for day in 1...31 {
//            if day < 10 {
//                daysBtnMenu.dropView.dropDownOptions.append("\(day) ")
//                continue
//            }
//            daysBtnMenu.dropView.dropDownOptions.append("\(day)")
//        }
//        //add arrow to button
//        daysBtnMenu.setImage(downArrow, for: .normal)
//        daysBtnMenu.imageView?.contentMode = .scaleAspectFit
//        arrowPosDay = daysBtnMenu.frame.width*0.40
//        daysBtnMenu.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:arrowPosDay)
//
//
//        //MARK: Months Menu
//        monthsBtnMenu = dropDownBtn3.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        monthsBtnMenu.translatesAutoresizingMaskIntoConstraints = false
//        monthsBtnMenu.setTitle("الشهر ", for: .normal)
//
//        //add bottom border
//        monthsBtnMenu.addBottomBorder(lineColor, height: 1)
//        //colors and text alignment
//        monthsBtnMenu.backgroundColor = .white
//        monthsBtnMenu.setTitleColor(UIColor(red: 227/255, green: 228/255, blue: 228/255, alpha: 1), for: .normal)
//        monthsBtnMenu.contentHorizontalAlignment = .right
//        //Add Button to the View Controller
//        self.view.addSubview(monthsBtnMenu)
//        //days button Constraints
//        monthsBtnMenu.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor, constant: 5).isActive = true
//        monthsBtnMenu.trailingAnchor.constraint(equalTo: daysBtnMenu.leadingAnchor,constant: -35).isActive = true
//        monthsBtnMenu.leadingAnchor.constraint(equalTo: daysBtnMenu.trailingAnchor,constant: 65).isActive = true
//
//        //monthsBtnMenu.widthAnchor.constraint(equalToConstant: birthdateLabel.frame.width+6).isActive = true
//
//        monthsBtnMenu.widthAnchor.constraint(equalTo: nameField.widthAnchor, multiplier: 0.25, constant: 0).isActive = true
//
//        monthsBtnMenu.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        //Set the drop down menu's options
//        for month in 1...12 {
//            monthsBtnMenu.dropView.dropDownOptions.append(" \(month)")
//        }
//
//        //add arrow to button
//        monthsBtnMenu.setImage(downArrow, for: .normal)
//        monthsBtnMenu.imageView?.contentMode = .scaleAspectFit
//        arrowPosMonth = monthsBtnMenu.frame.width*0.4
//        monthsBtnMenu.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:arrowPosMonth)
//
//
//        //MARK: Years Menu
//        yearsBtnMenu = dropDownBtn4.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        yearsBtnMenu.translatesAutoresizingMaskIntoConstraints = false
//        yearsBtnMenu.setTitle("السنة ", for: .normal)
//
//        //add bottom border
//        yearsBtnMenu.addBottomBorder(lineColor, height: 1)
//        //colors and text alignment
//        yearsBtnMenu.backgroundColor = .white
//        yearsBtnMenu.setTitleColor(UIColor(red: 227/255, green: 228/255, blue: 228/255, alpha: 1), for: .normal)
//        yearsBtnMenu.contentHorizontalAlignment = .right
//        //Add Button to the View Controller
//        self.view.addSubview(yearsBtnMenu)
//        //days button Constraints
//        yearsBtnMenu.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor, constant: 5).isActive = true
//        //yearsBtnMenu.trailingAnchor.constraint(equalTo: monthsBtnMenu.trailingAnchor,constant: -115).isActive = true
//
//
//        //yearsBtnMenu.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: view.trailingAnchor, multiplier: 0.85).isActive = true
//
//
//        yearsBtnMenu.leadingAnchor.constraint(equalTo: patientWeight.leadingAnchor,constant: 0).isActive = true
//        //yearsBtnMenu.widthAnchor.constraint(equalToConstant: birthdateLabel.frame.width+6).isActive = true
//
//        yearsBtnMenu.widthAnchor.constraint(equalTo: nameField.widthAnchor, multiplier: 0.25, constant: 0).isActive = true
//
//
//        yearsBtnMenu.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        //Set the drop down menu's options
//        for year in 1930...2010 {
//            yearsBtnMenu.dropView.dropDownOptions.append(" \(year)")
//        }
//
//        //add arrow to button
//        yearsBtnMenu.setImage(downArrow, for: .normal)
//        yearsBtnMenu.imageView?.contentMode = .scaleAspectFit
//        arrowPosYear = yearsBtnMenu.frame.width*0.4
//        yearsBtnMenu.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:arrowPosYear)
//
        
        
        birthDateField.delegate = self
        datePicker = UIDatePicker(frame: CGRect(x: 10, y: 10, width: 300, height: 800))
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        createDatePicker()
        

        //To make CardView in registeration scrollable
        
        //1.observer for keyboard on appear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        //2.observer for keyboard on appear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        nameField.delegate = self
        nationalIDField.delegate = self
        doctorIDField.delegate = self
        patientHeight.delegate = self
        patientWeight.delegate = self
        patientWeight.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
        
     
        
    }
    
    
    
    
    
    // MARK: DatePicker
    func createDatePicker(){
        //toolbar for done button item
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        birthDateField.inputAccessoryView =  toolbar
        //assign datepicker to textField
        birthDateField.inputView = datePicker
    }

    
    @objc func donePressed(){
        
        //formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthDateField.font = UIFont(name: "System", size: 0.3*birthDateField.frame.width)
        
        
        let dateWithSpace = formatter.string(from: datePicker.date) + "  "
        
        birthDateField.text = dateWithSpace
        print("fucko \(dateWithSpace)")
        birthDateField.resignFirstResponder()
            }
    
    var isExpoand:Bool = false
    @objc func keyboardAppear(){
        
        if !isExpoand {
            print("execute mf")
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 200)
            isExpoand = true
        }
        
    }
    
    
    @objc func keyboardDisappear(){
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 200)
        isExpoand = false
    }
    
    @objc func dismissMyKeyboard(){
        //removes focus of phoneField
        //phoneField.resignFirstResponder()
        nameField.resignFirstResponder()
        nationalIDField.resignFirstResponder()
        doctorIDField.resignFirstResponder()
        patientHeight.resignFirstResponder()
        patientWeight.resignFirstResponder()
        patientWeight.resignFirstResponder()
        //diabetesBtnMenu.dismissDropDown()
    }
    

    
    

    @IBAction func submitPressed(_ sender: UIButton) {
       // print(diabetesOptions[segmentedDiabets.selectedIndex])
        
        if let Patientname = nameField.text,let doctorID  = doctorIDField.text, let patientHeight = patientHeight.text, let patientWeight = patientWeight.text,let birthDate = birthDateField.text,let nationalID = nationalIDField.text{
 
            
            let defualts = UserDefaults.standard
            defualts.set(doctorID, forKey: "doctorID")
            
            let newPatient = db.collection("doctors").document(doctorID).collection("patients").document(Auth.auth().currentUser!.uid)
            
            
            newPatient.setData(["Name":Patientname,"birthDate":birthDate,"Height":patientHeight,"Weight":patientWeight,"DiabetesType":diabetesOptions[segmentedDiabets.selectedSegmentIndex],"ID":newPatient.documentID,"doctorID":doctorID,"nationalID":nationalID])
            
            
            
            if(typeVC == "register"){//only set empty arrays at registeration to avoid removing user's data if they entered edit form
                newPatient.collection("weeks").document("week\(1)").setData(["afterReadings":[],"afterTimes":[],"deltaAfterTimes":[],"beforeReadings":[],"beforeTimes":[],"deltaBeforeTimes":[]])
                
            }
            
            typeVC = "register"
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

//here
protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

class dropDownBtn: UIButton, dropDownProtocol {
    func dropDownPressed(string: String) {
       print("works 1")
        
        self.setTitle(" \(string)", for: .normal)
        self.dismissDropDown()
        
        self.setTitleColor(.black, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        
        //calculate inset size depending on word length
        let titleLength = self.currentTitle?.count
        
           
        self.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:CGFloat(titleLength!+(280-titleLength!)))
        print("in diabets menu")
       
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("works 33")
        self.backgroundColor = .white
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        print("works 2")
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
            if self.tag == 1 {
                print("fuckkkk")
            }
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


class dropDownBtn2: UIButton, dropDownProtocol {//day class
    func dropDownPressed(string: String) {
       
        self.setTitle(" \(string)", for: .normal)
        self.dismissDropDown()
        updateDaysBtn()
        //print("heyy")
        
        self.setTitleColor(.black, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        
        //calculate inset size depending on word length
        let titleLength = self.currentTitle?.count
        self.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:CGFloat(titleLength!+(Int(self.frame.width*0.55)-titleLength!)))
            print("in days menu")

    }

    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
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
            if self.tag == 1 {
                print("fuckkkk")
            }
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


class dropDownBtn3: UIButton, dropDownProtocol {
    func dropDownPressed(string: String) {
       
        
        self.setTitle(" \(string)", for: .normal)
        self.dismissDropDown()
        //updateDaysBtn()
        //print("heyy")
        
        self.setTitleColor(.black, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        
        //calculate inset size depending on word length
        let titleLength = self.currentTitle?.count
        self.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:CGFloat(titleLength!+(43-titleLength!)))
            print("in months menu")

    }

    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
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
            if self.tag == 1 {
                print("fuckkkk")
            }
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


class dropDownBtn4: UIButton, dropDownProtocol {
    func dropDownPressed(string: String) {
       
        
        self.setTitle(" \(string)", for: .normal)
        self.dismissDropDown()
        //updateDaysBtn()
        //print("heyy")
        
        self.setTitleColor(.black, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        
        //calculate inset size depending on word length
        let titleLength = self.currentTitle?.count
        self.imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:0, right:CGFloat(titleLength!+(43-titleLength!)))
            print("in months menu")

    }

    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
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
            if self.tag == 1 {
                print("fuckkkk")
            }
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
        tableView.layer.zPosition = 1
        tableView.contentSize = CGSize(width: 300, height: 300)
        tableView.backgroundColor = UIColor.gray
        self.backgroundColor = UIColor.black
        
        
        tableView.delegate = self
        tableView.dataSource = self
   
        //tableView.allowsFocus = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.layer.zPosition = 1000
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.isScrollEnabled = true;
        tableView.alwaysBounceVertical = false;
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isScrollEnabled = true;
        tableView.alwaysBounceVertical = false;
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        tableView.isScrollEnabled = true;
        tableView.alwaysBounceVertical = false;
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.textAlignment = .right
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        cell.backgroundColor = UIColor(red: 227/255, green: 228/255, blue: 228/255, alpha: 1)
        //cell.layer.zPosition = 1000
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hey1000")
       tableView.isScrollEnabled = true;
       tableView.alwaysBounceVertical = false;
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
    
    func setIcon(_ image: UIImage,_ pos: Int) {
       let iconView = UIImageView(frame:
                                    CGRect(x: pos, y: 0, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 25))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
          let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
          self.leftView = paddingView
          self.leftViewMode = .always
      }
      func setRightPaddingPoints(_ amount:CGFloat) {
          let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
          self.rightView = paddingView
          self.rightViewMode = .always
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

    func updateDaysBtn(){
        
    }
}
