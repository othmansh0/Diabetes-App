//
//  PatientViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 11/7/21.
//
import Firebase
import UIKit

class PatientViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UITabBarDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var collectionViewTwo: UICollectionView!
    @IBOutlet weak var collectionViewOne: UICollectionView!
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewLayout2: UICollectionViewFlowLayout!
    
    var plusButtonTag = 1
    @IBOutlet weak var welcomeLabel: UILabel!
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var doctorID:String!
    var openedDate:String!
    
    
    
    
    var weeksCount = UserDefaults.standard.integer(forKey: "weeksCount")
    var timer: Timer?
    var runCount = 0
    
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
        //weeksCount = defaults.integer(forKey: "weeksCount")
       
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

        Patient.sharedInstance.afterReadings = fetchReadings(tag: 1)
        Patient.sharedInstance.beforeReadings = fetchReadings(tag: 2)
        
        
        
        
        //gets last opened date from user defaults
        openedDate = defaults.string(forKey: "openedDate")
        
        //compare last opened with current date if number of weeks is greater than 1 then set number of weeks
        
        
        //convert last opened date & current to seconds then to weeks by dividing over 608400
        
        //
        
        
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        let opendDateAsDate = formatter.date(from: openedDate)
        print("opened date as a date \(opendDateAsDate)")
        
        let delta = (opendDateAsDate!.timeIntervalSince1970 - now.timeIntervalSince1970)/608400
        //check number of weeks
        if delta >= 1 {
            weeksCount += Int(ceil(delta))
        }
        
        
        
        let nowString = formatter.string(from: now)
        
        //set opened date to current date
        defaults.set(nowString, forKey: "openedDate")
        print("opened date is \(nowString)")
        
        
        
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "Chart") as? ChartViewController{
//
//            vc.beforeReadings = beforeReadings
//            vc.beforeTimes = beforeTimes
//            vc.num = 1
//            tabBarController?.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
   
 
    
    
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
            //print("error reading must be a number between 0 and 300")
            dismissSheet()
            return
        }
        
        
        let now = Date()
        
        //formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "EEEE - hh:mm:ss a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let englishDateString: String = getEnglishTime(time: now)
        let englishDate: Date = dateFormatter.date(from: englishDateString)!
        
       
        
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: englishDate)
        print("day is \(day)")
        print("time interval is \(englishDate.timeIntervalSince1970)")
        
        let cal = Calendar.current
        let startOfday = cal.startOfDay(for: englishDate)
        let secondsVal = (englishDate.timeIntervalSince1970 - startOfday.timeIntervalSince1970)/86000
        print("time of day in chart is\(secondsVal)")

    
        var plot:Double!
        if day == "Sunday"{
            print("in Sunday")
             plot = 0.0 + secondsVal
            print("plot \(plot!)")
            
        }
        else if day == "Monday"{
            print("in Monday")
             plot = 1.0 + secondsVal
            print("plot \(plot!)")
            
        }
        else if day == "Tuesday"{
            print("in Tuesday")
             plot = 2.0 + secondsVal
            print("plot \(plot!)")
            
        }
        else if day == "Wednesday"{
            print("in Wednesday")
            plot = 3.0 + secondsVal
            print("plot \(plot!)")
            
        }
        else if day == "Thursday"{
            print("in Thursday")
            plot = 4.0 + secondsVal
            print("plot \(plot!)")
            
        }
        else if day == "Friday"{
            print("in Friday")
            plot = 5.0 + secondsVal
            print("plot \(plot!)")
            
        }
        else if day == "Saturday"{
            print("in Saturday")
            plot = 6.0 + secondsVal
            print("plot \(plot!)")
            
            
        }
        else {
            fatalError("error trying to calculate plot in patientviewcontroller")
        }
        
//        if(runCount == 0) {//to avoid starting a timer on every press
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//        }
        
        
        
        
        
        
        
        
        if  plusButtonTag == 1{
             //afterReadings.insert(reading, at: 0)
            //afterTimes.insert(englishDateString, at: 0)
            Patient.sharedInstance.afterReadings.insert(reading, at: 0)
            Patient.sharedInstance.afterTimes.insert(englishDateString, at: 0)
            Patient.sharedInstance.deltaAfterTimes.insert(String(plot), at: 0)
            print("english date before writing to firestore \(englishDateString)")

            writeReading(tag: 1, with: reading,at: englishDateString)
            
            } else {
//                    beforeReadings.insert(reading, at: 0)
//                    beforeTimes.insert(dateString, at: 0)
                    Patient.sharedInstance.beforeReadings.insert(reading, at: 0)
                    Patient.sharedInstance.beforeTimes.insert(englishDateString, at: 0)
                Patient.sharedInstance.deltaBeforeTimes.insert(String(plot), at: 0)
                    writeReading(tag: 2, with: reading,at: englishDateString)
                    
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
            //print(reading)
            if tag == 1{
                Patient.sharedInstance.afterReadings.insert(reading, at: 0)
                
                //self.writeReading(tag: 1, with: reading)
             
            }else {
               Patient.sharedInstance.beforeReadings.insert(reading, at: 0)
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
        var deltaReadingsType = ""
       var readingsArray = [String]()
       var TimesArray = [String]()
        var deltaTimesArray = [String]()
        if tag == 1 {
            readingsType = "afterReadings"
            timesType = "afterTimes"
            deltaReadingsType = "deltaAfterTimes"
           // print("tag is\(tag)")
        } else { readingsType = "beforeReadings"
            timesType = "beforeTimes"
            deltaReadingsType = "deltaBeforeTimes"
            //print("tag is\(tag)")
        }
        
        //get ref of patient
        
        DispatchQueue.main.async {
            
            let patient = self.db.collection("doctors").document(self.doctorID).collection("patients").document(Auth.auth().currentUser!.uid).collection("weeks").document("week\(self.weeksCount)")
            print(patient)
            
            patient.getDocument { document, error in
                if let document = document,document.exists {
                    guard let dataDescription = document.data() else {
                        print("------------------------------------------------------------------------------------")
                        print("error empty document")
                        print("------------------------------------------------------------------------------------")
                        return
                        
                    }
                    //print("------------------------------------------------------------------------------------")
                   // print("Document data: \(dataDescription)")
                    //print("------------------------------------------------------------------------------------")
                    
                    //fetch arrays from firebase
                    readingsArray = dataDescription[readingsType] as? [String] ?? ["error fetching array from firebase"]
        
                    TimesArray = dataDescription[timesType] as? [String] ?? ["error fetching array from firebase"]
                    
                   
                    if tag == 1 {
                        Patient.sharedInstance.afterReadings = readingsArray.reversed()
                        
                        Patient.sharedInstance.afterTimes = TimesArray.reversed()
                        deltaTimesArray = dataDescription[deltaReadingsType] as? [String] ?? ["error fetching array from firebase"]
                        
                        self.collectionViewOne.reloadData()
                        Patient.sharedInstance.deltaAfterTimes = deltaTimesArray.reversed()
                    } else {
                        Patient.sharedInstance.beforeReadings = readingsArray.reversed()
                        Patient.sharedInstance.beforeTimes = TimesArray.reversed()
                        deltaTimesArray = dataDescription[deltaReadingsType] as? [String] ?? ["error fetching array from firebase"]
                        self.collectionViewTwo.reloadData()
                        Patient.sharedInstance.deltaBeforeTimes = deltaTimesArray.reversed()
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
        
        return readingsArray
    }
    
    func writeReading(tag: Int,with reading: String,at time:String){
        //decides which array to update
        var readingsType = ""
        var readingsTime = ""
        var deltaReadingsType = ""
         if tag == 1 {
             readingsType = "afterReadings"
             readingsTime = "afterTimes"
             deltaReadingsType = "deltaAfterTimes"
         } else {
             readingsType = "beforeReadings"
             readingsTime = "beforeTimes"
             deltaReadingsType = "deltaBeforeTimes"
    }
        print("weeks count is\(weeksCount)")
        let patient = db.collection("doctors").document(doctorID).collection("patients").document(Auth.auth().currentUser!.uid).collection("weeks").document("week\(weeksCount)")
        print("readings time is fuck \(readingsTime)")
        patient.updateData([readingsTime:FieldValue.arrayUnion([time])]) { error in
            print("error updating data")
        }
        if tag == 1 {
            patient.setData([readingsType:Patient.sharedInstance.afterReadings,deltaReadingsType:Patient.sharedInstance.deltaAfterTimes], merge: true)
            
        }
        else {
            patient.setData([readingsType:Patient.sharedInstance.beforeReadings,deltaReadingsType:Patient.sharedInstance.deltaBeforeTimes], merge: true)
        }
        
  

    
}
    
    
    
//    @objc func fireTimer() {
//        let startTime = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        let startDate = formatter.string(from: startTime)
//
//        runCount += 1
//        if runCount == 1 {//push start date to firebase
//            print("Timer fired!\(startDate)")
//        }
//        if runCount == 604801  {//push end date to firebase  after a week finishes
//            timer?.invalidate()
//            let endTime = Date()
//            let endDate = formatter.string(from: endTime)
//            print("Timer ended!\(endDate)")
//            weeksCount += 1
//            UserDefaults.standard.set(weeksCount, forKey: "weeksCount")
//            runCount = 0
//        }
//    }
    
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
        UIView.animate(withDuration: 0.5) {
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
            return Patient.sharedInstance.beforeReadings.count
        }
        
        return Patient.sharedInstance.afterReadings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewTwo {
            let cell2 = readingCard.setupCell(collectionView: collectionView, indexPath: indexPath, readings: Patient.sharedInstance.beforeReadings,readingsTime: Patient.sharedInstance.beforeTimes,cellName: "Cell2")
            return cell2
        }
        else {
            let cell = readingCard.setupCell(collectionView: collectionView, indexPath: indexPath, readings: Patient.sharedInstance.afterReadings,readingsTime: Patient.sharedInstance.afterTimes,cellName: "Cell")
        return cell
        }
        
    }
  
    public func getEnglishTime(time:Date)->String{

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeStyle = .short
        formatter.dateFormat = "EEEE - hh:mm:ss a"
        
        let dateString: String = formatter.string(from: time)
        return dateString
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






extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
    
    
    
 
