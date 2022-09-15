//
//  PatientViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 11/7/21.
//
import Firebase
import UIKit

class PatientViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UITabBarDelegate, UITabBarControllerDelegate, UITableViewDelegate{

    
    
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var afterEattingbtn: UIButton!
    @IBOutlet weak var beforeEattingbtn: UIButton!
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
    
    //Side Menu
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    
    
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    
    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    private var revealSideMenuOnTop: Bool = true
    
    private var sideMenuShadowView: UIView!
    
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    
    @IBAction open func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
  
 //personal info vars
 var userName = ""
 var diabetesType = ""
 var height = ""
 var weight = ""
 var birthdate = ""
 var docID = ""
 var nationalID = ""
    
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doctorID = defaults.string(forKey: "doctorID")
        Patient.sharedInstance.doctorID = doctorID
        Patient.sharedInstance.weeksCount = weeksCount
        DispatchQueue.main.async {
            self.fetchPersonalInfo()
            Patient.sharedInstance.patientName = self.userName
            self.patientName.text = self.userName
            self.patientName.textAlignment = .left
            print("fuck patient \(self.patientName.text)")
            
        }
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
      
       
        //weeksCount = defaults.integer(forKey: "weeksCount")
       print("weeks count in vc is \(weeksCount)")
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
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
//        view.addGestureRecognizer(tap)

        Patient.sharedInstance.afterReadings = fetchReadings(tag: 1)
        Patient.sharedInstance.beforeReadings = fetchReadings(tag: 2)
        
        
        
        
        //gets last opened date from user defaults
        openedDate = defaults.string(forKey: "openedDate")
        
        
        
        
        
        
        
        
        let now = Date.getCurrentDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        //let tempDate = "10/08/2022 03:53:33"
        //let tempDateAsDate = formatter.date(from: tempDate)
        let opendDateAsDate = formatter.date(from: openedDate)
        print("opened date as a date \(opendDateAsDate)")
        //print("temp date as a date \(tempDateAsDate)")
        
        //compare last opened with current date if number of weeks is greater than 1 then set number of weeks
        //convert last opened date & current to seconds then to weeks by dividing over 608400
        let now2 = formatter.date(from: now)!
        print("opened date as seconds is \(opendDateAsDate!.timeIntervalSince1970)")
        print("current date as seconds is \(now2.timeIntervalSince1970)")
       let delta = (now2.timeIntervalSince1970/608400 - opendDateAsDate!.timeIntervalSince1970/608400)
       //let delta = (now2.timeIntervalSince1970/608400 - tempDateAsDate!.timeIntervalSince1970/608400)
        //check number of weeks
        print("delta is \(delta)")
        if delta >= 1 {
            
            weeksCount += Int(ceil(delta))
            UserDefaults.standard.set(weeksCount, forKey: "weeksCount")
            Patient.sharedInstance.weeksCount = weeksCount
            let patient = db.collection("doctors").document(doctorID).collection("patients").document(Auth.auth().currentUser!.uid).collection("weeks").document("week\(weeksCount)")
            
            patient.setData(["afterReadings":[],"afterTimes":[],"deltaAfterTimes":[],"beforeReadings":[],"beforeTimes":[],"deltaBeforeTimes":[]])
        }
        
        
       
        
        let nowString = formatter.string(from: now2)
        //set opened date to current date
        defaults.set(nowString, forKey: "openedDate")
        print("opened date as current date is \(nowString)")
        
        //MARK: Side Menu

        
        
        
        // Side Menu Gestures
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            panGestureRecognizer.delegate = self
            view.addGestureRecognizer(panGestureRecognizer)
        
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop {
            view.insertSubview(self.sideMenuShadowView, at: 2)
        }
        
        // Side Menu
        // Side Menu
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuID") as? SideMenuViewController
        self.sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        self.sideMenuViewController.delegate = self
        view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 7 : 0)
        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)
        
        
        print("fuck22")
        
        // Side Menu AutoLayout
        
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: +self.sideMenuRevealWidth + self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        // ...
        
        
        //sideMenuViewController.view.isUserInteractionEnabled = true
          //  sideMenuViewController.view.sendSubviewToBack(beforeEattingbtn)
//        self.view.bringSubviewToFront(self.sideMenuViewController.view)
       // beforeEattingbtn.layer.zPosition = -1
    
        // Default Main View Controller
       // showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
        
        sideMenuViewController.view.layer.zPosition = 2
        
        sideMenuBtn.target = revealViewController()
                sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        //sideMenuViewController.sideMenuTableView.delegate = self
       // sideMenuViewController.sideMenuTableView.dataSource = self
       
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = self.isExpanded ? 0 : (-self.sideMenuRevealWidth - self.paddingForRotation)
            }
        }
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

    func fetchPersonalInfo(){
       
        
        
        let patient = self.db.collection("doctors").document(self.doctorID).collection("patients").document(Auth.auth().currentUser!.uid)
        patient.getDocument { document, error in
            
            
            if let document = document,document.exists {
                guard let dataDescription = document.data() else {
                    print("------------------------------------------------------------------------------------")
                    print("error empty document")
                    print("------------------------------------------------------------------------------------")
                    return
                    
                }
                self.userName = dataDescription["Name"] as? String  ?? "no name"
                self.diabetesType = dataDescription["DiabetesType"] as? String  ?? "no diabetes type"
                self.height = dataDescription["Height"] as? String  ?? "no height"
                self.weight = dataDescription["Weight"] as? String  ?? "no weight"
                self.birthdate = dataDescription["birthDate"] as? String  ?? "no birthdate"
                self.docID = dataDescription["doctorID"] as? String  ?? "no doctor ID"
                self.nationalID = dataDescription["nationalID"] as? String  ?? "no national ID"
                print("my name is \(self.userName) \(self.diabetesType) \(self.height) \(self.weight) \(self.docID) \(self.birthdate) ")
                
                
            
            
        }
    }
    }
    
    
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

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
     dateFormatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
     dateFormatter.locale = Locale(identifier: "en_US_POSIX")
     dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: Date())

    }
}
    
    
 
extension PatientViewController: SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            // Home
            print("home1")
            if let vc = storyboard?.instantiateViewController(withIdentifier: "PatientR") as? PatientRegisterationViewController {
                vc.typeVC = "edit" //change flag so form opens in editting mode not registeration
               
                vc.userName = userName
                vc.diabetesType = diabetesType
                vc.height = height
                vc.weight = weight
                vc.birthdate = birthdate
                vc.docID = docID
                vc.nationalID = nationalID
                
                  navigationController?.pushViewController(vc, animated: true)
         
            }
        case 1:
            
            print("home2")
        default:
            print("broke")
            break
        }
        
        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }
    
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        // Remove the previous View
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = 99
        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 2)
        addChild(vc)
        if !self.revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
            if self.sideMenuShadowView != nil {
                vc.view.addSubview(self.sideMenuShadowView)
                
            }
        }
        vc.didMove(toParent: self)
    }
    
    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
                print("yaudu")
                self.tabBarController?.tabBar.isHidden = true

            }
            // Animate Shadow (Fade In)
           

            UIView.animate(withDuration: 0.7) {
                self.sideMenuShadowView.alpha = 0.6
                self.tabBarController?.tabBar.alpha = 0
                self.afterEattingbtn.isEnabled = false
                self.navigationItem.setRightBarButton(nil, animated: true)
            }
           
           
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (self.sideMenuRevealWidth + self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
                
                self.tabBarController?.tabBar.isHidden = false

            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.7) {
                self.sideMenuShadowView.alpha = 0.0
                self.tabBarController?.tabBar.alpha = 1
                self.afterEattingbtn.isEnabled = true
                self.navigationItem.setRightBarButton(self.sideMenuBtn, animated: true)

            }
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}
extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> PatientViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is PatientViewController {
         
            return viewController! as? PatientViewController
        }
        while (!(viewController is PatientViewController) && viewController?.parent != nil) {
            
            viewController = viewController?.parent
        }
        if viewController is PatientViewController {
           
            return viewController as? PatientViewController
        }
        return nil
    }
    // Call this Button Action from the View Controller you want to Expand/Collapse when you tap a button
    
    
}

extension PatientViewController: UIGestureRecognizerDelegate {
    
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
    
    // Dragging Side Menu
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        // ...

        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x

        switch sender.state {
        case .began:

            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }

            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging they collapsing the side menu)
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }

            if self.draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }

                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }

        case .changed:

            // Expand/Collapse side menu while dragging
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha

                    // Move side menu while dragging
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                       // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        self.sideMenuShadowView.alpha = alpha

                        // Move side menu while dragging
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
}
