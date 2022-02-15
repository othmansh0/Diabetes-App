//
//  PatientViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 11/7/21.
//
import Firebase
import UIKit

class PatientViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionViewTwo: UICollectionView!
    @IBOutlet weak var collectionViewOne: UICollectionView!
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewLayout2: UICollectionViewFlowLayout!
    
    var plusButtonTag = 1
    @IBOutlet weak var welcomeLabel: UILabel!
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var doctorID:String!
    //Bottom Sheet
    @IBOutlet weak var bottomSheet: UIView!
    @IBOutlet weak var readingField: UITextField!
    @IBOutlet weak var sheetLabel: UILabel!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewLeadingConstraint: NSLayoutConstraint!
    
    var afterReadings = [String]()
    var afterTimes = [String]()
    var beforeReadings = [String]()
    var beforeTimes = [String]()
    var readingCard = ReadingCard()
    private var isBottomSheetShown = false
    var blurView = UIVisualEffectView()
    var blurEffect = UIBlurEffect()

    private var indexOfCellBeforeDragging = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorID = defaults.string(forKey: "doctorID")
        
       
        tabBarController?.tabBar.layer.cornerRadius = 15
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout2.minimumLineSpacing = 5
        collectionViewOne.tag = 1
        collectionViewTwo.tag = 2
        let rgbColor =  UIColor(red: CGFloat(139.0/255.0), green: CGFloat(164.0/255.0), blue: CGFloat(170.0/255.0), alpha: 1)
        readingField.addBorderAndColor(color: rgbColor, width: 3, corner_radius: 20, clipsToBounds: true)
        //MARK: bottomsheet design
        bottomSheet.layer.cornerRadius = 40
        bottomSheet.clipsToBounds = true
        
        //makes UIView clickable
             let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
             view.addGestureRecognizer(tap)

       afterReadings = fetchReadings(tag: 1)
       beforeReadings = fetchReadings(tag: 2)

       
      
       
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       configureCollectionViewLayoutItemSize(collectionViewLayout: collectionViewLayout)
        configureCollectionViewLayoutItemSize(collectionViewLayout: collectionViewLayout2)
    }
    
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        //after or before eating button got pressed
        //addReading(tag: sender.tag)
        //showBottomSheet()
        
        
        //before button pressed
        if sender.tag == 2 {
            sheetLabel.text = "قبل الأكل"
            plusButtonTag = 2
        }
        else {//after button pressed
            sheetLabel.text = "بعد الأكل"
            plusButtonTag = 1
        }
        
        // 2 create blur effect
        blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
       
        // 4
        blurView.translatesAutoresizingMaskIntoConstraints = false
        // 3 display the blur effect created with animation
        UIView.animate(withDuration: 1){
            self.blurView.effect = self.blurEffect
            self.view.insertSubview(self.blurView, at:5)
        }

        // 1
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        // 2
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        // 3
        for subview in self.blurView.subviews {
            vibrancyView.contentView.addSubview(subview)
        }

        // 4
        self.blurView.contentView.addSubview(vibrancyView)

        
        NSLayoutConstraint.activate([
          blurView.topAnchor.constraint(equalTo: view.topAnchor),
          blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
          blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        stretchBottomSheet()
    }
    
    //Bottom sheet button pressed
    @IBAction func addReading(_ sender: UIButton) {
        guard let reading = readingField.text,!reading.isEmpty else {
            dismissSheet()
            return }
        if reading.count > 3 {
            print("error reading must be a number between 0 and 300")
            dismissSheet()
            return
        }
        
        
        let now = Date()
        
       
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        
        formatter.timeStyle = .short
        //use ar for arabic numbers
        formatter.locale = NSLocale(localeIdentifier: "ar_DZ") as Locale
        formatter.dateFormat = "EEEE -  hh:mm a"
        formatter.amSymbol = "صباحا"
        formatter.pmSymbol = "مساءا"
        
        let dateString = formatter.string(from: now)
       
        print(dateString)
        
        if  plusButtonTag == 1{
             afterReadings.insert(reading, at: 0)
            afterTimes.insert(dateString, at: 0)
            writeReading(tag: 1, with: reading,at: dateString)
            
            }else {
                    beforeReadings.insert(reading, at: 0)
                    beforeTimes.insert(dateString, at: 0)
                    writeReading(tag: 2, with: reading,at: dateString)
                    
                 }
        dismissSheet()
        collectionViewOne.reloadData()
        collectionViewTwo.reloadData()
        removeBlur()
        
    }
    
    @IBAction func closeSheet(_ sender: UIButton) {
        dismissSheet()
        removeBlur()
    
    }
    
    func removeBlur(){
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        view.backgroundColor = .white
        blurView.effect = nil
    }
    
    
    //another option to enter readings using alert
    func addReading(tag:Int){
        let alert = UIAlertController(title: "أدخل قراءة بعد الأكل", message: "", preferredStyle: .alert)
        alert.addTextField()
        let action = UIAlertAction(title: "enter please", style: .default) { action in
            guard let reading = alert.textFields?[0].text else {return}
            print(reading)
            if tag == 1{
                self.afterReadings.insert(reading, at: 0)
                //self.writeReading(tag: 1, with: reading)
             
            }else {
                self.beforeReadings.insert(reading, at: 0)
               // self.writeReading(tag: 2, with: reading)
            }
            self.collectionViewOne.reloadData()
            self.collectionViewTwo.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true)

    }
    
    //MARK: Firestore

    func fetchReadings(tag: Int) -> [String]{
       //decides which array needs to be fetched from firestore
       var readingsType = ""
        var timesType = ""
       var readingsArray = [String]()
       var TimesArray = [String]()
        if tag == 1 {
            readingsType = "afterReadings"
            timesType = "afterTimes"
            print("tag is\(tag)")
        } else { readingsType = "beforeReadings"
            timesType = "beforeTimes"
            print("tag is\(tag)")
        }
        
        //get ref of patient
        
        DispatchQueue.main.async {
            let patient = self.db.collection("doctors").document(self.doctorID).collection("patients").document(Auth.auth().currentUser!.uid)
            
            
            patient.getDocument { document, error in
                if let document = document,document.exists {
                    guard let dataDescription = document.data() else {
                        print("------------------------------------------------------------------------------------")
                        print("error empty document")
                        print("------------------------------------------------------------------------------------")
                        return
                        
                    }
                    print("------------------------------------------------------------------------------------")
                    print("Document data: \(dataDescription)")
                    print("------------------------------------------------------------------------------------")
                    readingsArray = dataDescription[readingsType] as? [String] ?? ["!"]
        
                    TimesArray = dataDescription[timesType] as? [String] ?? ["!"]
                    
                    if tag == 1 {
                        self.afterReadings = readingsArray
                        self.afterTimes = TimesArray
                        self.collectionViewOne.reloadData()
                    } else {
                        self.beforeReadings = readingsArray
                        self.beforeTimes = TimesArray
                        self.collectionViewTwo.reloadData()
                    }
                    
                    
                  
           
                    print("------------------------------------------------------------------------------------")
                    print(readingsArray)
                    print("------------------------------------------------------------------------------------")
                    //return readingsArray
                } else {
                    print("error")
                    return
                }
            }
            
        }
        
        return readingsArray.reversed()
    }
    
    func writeReading(tag: Int,with reading: String,at time:String){
        //decides which array to update
        var readingsType = ""
        var readingsTime = ""
         if tag == 1 {
             readingsType = "afterReadings"
             readingsTime = "afterTimes"
         } else {
             readingsType = "beforeReadings"
             readingsTime = "beforeTimes"
    }
        let patient = db.collection("doctors").document(doctorID).collection("patients").document(Auth.auth().currentUser!.uid)
        
        patient.updateData([readingsType:FieldValue.arrayUnion([reading]),readingsTime:FieldValue.arrayUnion([time])]) { error in
            print("error updating data")
        }

    
}
    
}




//MARK: Bottom Sheet
extension PatientViewController {
    //MARK: Bottom Sheet Animation (NEDINE)
    public func stretchBottomSheet(){
        //shows keyboard when bottom sheet is open
        readingField.becomeFirstResponder()
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
    
    //MARK: bottom sheet closing animation (NEDINE)
    @objc func dismissSheet(){
        readingField.text = ""
        //closes keyboard
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.bottomViewHeightConstraint.constant = 0
            self.removeBlur()
            // update view layout immediately
            self.view.layoutIfNeeded()
        } completion: { status in
            self.isBottomSheetShown = false
        }
    }
    
    

    
}



//MARK: CollectionView
extension PatientViewController {
    private func calculateSectionInset(collectionViewLayout:UICollectionViewFlowLayout) -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 360 + (cellBodyViewIsExpended ? 174 : 0)
        
        let buttonWidth: CGFloat = 79
        
        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
        return inset
    }
    
    private func configureCollectionViewLayoutItemSize(collectionViewLayout:UICollectionViewFlowLayout) {
        let inset: CGFloat = calculateSectionInset(collectionViewLayout: collectionViewLayout) //inset calculation so the next and the previous cells will peek from the sides
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width-10 - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
    }
    
    private func indexOfMajorCell(collectionViewLayout:UICollectionViewFlowLayout) -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(afterReadings.count - 1, index))
        return safeIndex
    }
    
    // ===================================
    // MARK: - UICollectionViewDataSource:
    // ===================================
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewTwo {
            return beforeReadings.count
        }
        
        return afterReadings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewTwo {
            let cell2 = readingCard.setupCell(collectionView: collectionView, indexPath: indexPath, readings: beforeReadings,readingsTime: beforeTimes,cellName: "Cell2")
            return cell2
        }
        else {
        let cell = readingCard.setupCell(collectionView: collectionView, indexPath: indexPath, readings: afterReadings,readingsTime: afterTimes,cellName: "Cell")
        return cell
        }
        
    }
  
}

extension UIView {
    func addBorderAndColor(color: UIColor, width: CGFloat, corner_radius: CGFloat = 0, clipsToBounds: Bool = false) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = corner_radius
        self.clipsToBounds = clipsToBounds
    }
}





    
    
    
 
