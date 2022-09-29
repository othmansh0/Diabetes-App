//
//  PatientDetailViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/23/22.
//

import UIKit
import Charts
import Firebase
import FirebaseStorage
class PatientDetailViewController: UIViewController {
    var isPushing = false
    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var weeksLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var patientName: UILabel!
    
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    @IBOutlet weak var weeksLabelBtmCon: NSLayoutConstraint!
    @IBOutlet weak var chaetBtmConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewTopCons: NSLayoutConstraint!
    @IBOutlet weak var textViewBtmCons: NSLayoutConstraint!
    let child = SpinnerViewController()
    var selectedPatient:Patient!
    var beforeReadings = [String]()
    var beforeTimes = [String]()
    var deltaBeforeTimes = [String]()
    
    var afterReadings = [String]()
    var afterTimes = [String]()
    var deltaAfterTimes = [String]()
    
    var userID:String!
    var doctorID:String!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    let defaults = UserDefaults.standard
    
    let beforeColor = UIColor(red: 133/255, green: 165/255, blue: 171/255, alpha: 1)
    let afterColor = UIColor(red: 255/255, green: 213/255, blue: 159/255, alpha: 1)
    let axisColor = UIColor(red: 133/255, green: 165/255, blue: 171/255, alpha: 1)
    let labelColor = UIColor(red: 133/255, green: 179/255, blue: 187/255, alpha: 1)
    
    var weeksIDS = [String]()
    var labsIDs = [String]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 245/255, alpha: 1)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.isHiddenHairline = true
        
        labsIDs = [String]()//to avoid duplicates of labs
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @objc func labsButton(){
        print("hey labs")
        
        
        
        //fetchLabs()
        fetchLabs { result in
            switch result{
            case .success(let c):
                
               
                
                
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorLabs") as? DoctorLabsViewController {
                    vc.flagy = 1
                    vc.labs = self.labsIDs
                    vc.userID = self.userID
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                self.alert(message: error.localizedDescription)
                
            }
        }
        
        
        //        if let vc = storyboard?.instantiateViewController(withIdentifier: "DoctorLabs") as? DoctorLabsViewController {
        //
        //            navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    enum NetworkError: Error {
        case badURL
    }
    
    
    func fetchLabs(completionHandler:@escaping (Result<Int,NetworkError>) -> Void)  {
        
        // add the spinner view controller
        self.addChild(child)
        child.view.frame = self.view.frame
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
        let storage = Storage.storage()
        let storageReference = storage.reference()
        storageReference.listAll { (result, error) in
            
            if let error = error {
                self.alert(message: error.localizedDescription)
                completionHandler(.failure(.badURL))
                return
            }
            
            
            var myPrefix:StorageReference?
            for prefix in result!.prefixes {//search for userID if it exists in storafe ie user uploaded at leasrt a one lab
                if prefix.name == self.userID { //To get user's storage only
                     myPrefix = prefix
                }
                //print(prefix.name)
                
            }
            
            
            if let myPrefix {
                // The prefixes under storageReference.
                // You may call listAll(completion:) recursively on them.
                print(myPrefix.name)
                myPrefix.listAll { result, error in
               
                    print(":fdf")
                   if let result2 = result?.prefixes{
                        for prefix in result2 {
                            print("labs: \(prefix.name)")
                            
                            prefix.listAll { result, error in
                                
                                for item in result!.items {//lab1 lab2
                                    print(item.name)
                                    self.labsIDs.append(item.name)
                                }
                                self.child.willMove(toParent: nil)
                                self.child.view.removeFromSuperview()
                                self.child.removeFromParent()
                                print("step 1")
                                completionHandler(.success(self.labsIDs.count))
                                
                            }
                        }
                    }
                    
                    
                }
            } else {//Show error msg if user hasnt uploaded any labs yet
                                self.alert(message: "لا يوجد للمريض أي مختبرات")
                self.child.willMove(toParent: nil)
                self.child.view.removeFromSuperview()
                self.child.removeFromParent()
                                return
            }
            
            
            //            //else user has no labs
            //            if self.labsIDs.isEmpty{
            //                self.alert(message: "لا يوجد للمريض أي مختبرات")
            //                child.willMove(toParent: nil)
            //                child.view.removeFromSuperview()
            //                child.removeFromParent()
            //                return
            //
            //            }
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorID = defaults.string(forKey: "doctorID")
        selectedPatient =  Patients.sharedInstance.allPatients[userID]
        patientName.text = selectedPatient.userName
        historyTextView.text = fetchHistory()
        for week in selectedPatient.weeksData.keys {
            
            weeksIDS.append(week)
            
        }
        
        
        
        //reverse array .reverse is buggy here
        
        weeksIDS = weeksIDS.sorted { $0 > $1 }
        //print(descendingStrings)
        print(weeksIDS)
        let str = "\(weeksIDS.first!)"
        weeksLabel.text = "أسبوع \(weeksIDS.first!.replacingOccurrences(of: "week", with: ""))"
        print("str \(str)")
        //show latest week data
        beforeReadings = selectedPatient.weeksData[str]?["beforeReadings"] ?? ["0"]
        beforeTimes = selectedPatient.weeksData[str]?["beforeTimes"] ?? ["0"]
        deltaBeforeTimes = selectedPatient.weeksData[str]?["deltaBeforeTimes"] ?? ["0"]
        
        afterReadings = selectedPatient.weeksData[str]?["afterReadings"] ?? ["0"]
        afterTimes = selectedPatient.weeksData[str]?["afterTimes"] ?? ["0"]
        deltaAfterTimes = selectedPatient.weeksData[str]?["deltaAfterTimes"] ?? ["0"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "المختبرات", style: .plain, target: self, action: #selector(labsButton))
        //remove back word from navigation button item for next view
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if(historyTextView.text.isEmpty){
            historyTextView.text = " \u{2022} " + historyTextView.text
        }
        
        
        
        Patient.sharedInstance.setupChart(chart: lineChart, beforeColor: beforeColor, afterColor: afterColor, axisColor: axisColor, labelColor: labelColor)
        Patient.sharedInstance.setupChartData(chart: lineChart, beforeReadings: beforeReadings, deltaBeforeTimes: deltaBeforeTimes, afterReadings: afterReadings, deltaAfterTimes: deltaAfterTimes,beforeColor:beforeColor,afterColor: afterColor,axisColor: axisColor)
        
        
        chaetBtmConstraint.constant = view.frame.height * 0.52725118
        
        weeksLabelBtmCon.constant = view.frame.height * -0.02725118
        print("height is \(view.frame.height)")
        
        textViewTopCons.constant = view.frame.height * 0.1528436
        textViewBtmCons.constant = view.frame.height * 0.06635071
        
        cardHeight.constant = view.frame.height * 0.53909953
        //cardHeight.constant = -400
        cardView.layer.cornerRadius = 40
        
        historyTextView.delegate = self
        historyTextView.layer.cornerRadius = 15
        historyTextView.layer.borderColor = UIColor(red: 133/255, green: 165/255, blue: 171/255, alpha: 0.3).cgColor
        historyTextView.layer.borderWidth = 2
    }
    
    
    
    var weekIndex = 0
    @IBAction func navigateChart(_ sender: UIButton) {
        var numberOfweeks = selectedPatient.weeksData.keys.count
        
        //next then weekIndex--
        //back then weekIndex++
        print("week index is \(weekIndex) & sender is \(sender.tag)")
        if sender.tag == 1 && weekIndex-1 >= 0 {//next button clicked
            weekIndex -= 1
            weeksLabel.text = "أسبوع \(weeksIDS[weekIndex].replacingOccurrences(of: "week", with: ""))"
            print("shit")
        }
        else if sender.tag == 2 && weekIndex+1 < numberOfweeks {//back button pressed
            weekIndex += 1
            weeksLabel.text = "أسبوع \(weeksIDS[weekIndex].replacingOccurrences(of: "week", with: ""))"
            
        }
        else {//do nothing
            return
        }
        
        
        let str = "\(weeksIDS[weekIndex])"
        
        //update readings and set data chart
        beforeReadings = selectedPatient.weeksData[str]?["beforeReadings"] ?? ["0"]
        beforeTimes = selectedPatient.weeksData[str]?["beforeTimes"] ?? ["0"]
        deltaBeforeTimes = selectedPatient.weeksData[str]?["deltaBeforeTimes"] ?? ["0"]
        
        afterReadings = selectedPatient.weeksData[str]?["afterReadings"] ?? ["0"]
        afterTimes = selectedPatient.weeksData[str]?["afterTimes"] ?? ["0"]
        deltaAfterTimes = selectedPatient.weeksData[str]?["deltaAfterTimes"] ?? ["0"]
        Patient.sharedInstance.setupChartData(chart: lineChart, beforeReadings: beforeReadings, deltaBeforeTimes: deltaBeforeTimes, afterReadings: afterReadings, deltaAfterTimes: deltaAfterTimes, beforeColor: beforeColor, afterColor: afterColor, axisColor: axisColor)
        
    }
    
    
    
    func setHistory(historyText:String){
        let patient = self.db.collection("doctors").document(doctorID!).collection("patients").document(userID)
        patient.setData(["History":historyText], merge: true)
        
    }
    func fetchHistory() -> String{
        return selectedPatient.history
        
    }
    
}
extension PatientDetailViewController:UITextViewDelegate{
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard navigationController?.topViewController == self else { return }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "historyDetail") as? HistoryDetailViewController {
            vc.delegate = self
            
            //To start on new line if history is not empty
            if historyTextView.text != "\u{2022}" && historyTextView.text.last != " "{
                vc.historytext = historyTextView.text + "\n \n \n \u{2022} "
            }
            else {
                vc.historytext = historyTextView.text
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}



extension PatientDetailViewController:TakingHistroyDelegate{
    func finishedTakingHistroy(text: String) {
        historyTextView.text = text
        setHistory(historyText: text)
    }
}

extension UINavigationController {
    
    var isHiddenHairline: Bool {
        get {
            guard let hairline = findHairlineImageViewUnder(navigationBar) else { return true }
            return hairline.isHidden
        }
        set {
            if let hairline = findHairlineImageViewUnder(navigationBar) {
                hairline.isHidden = newValue
            }
        }
    }
    
    private func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
    
}


//extension DoctorLabsViewController:UIDocumentPickerDelegate {
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//
//
//          guard let selectedFileURL = urls.first else {
//              return
//          }
//
//          print("upload to firebase")
//          //placed here so if a user doesnt add a file an empty lab cell wont be added
////          labsCounter += 1
////          labsCells.append(labsCounter)
////          UserDefaults.standard.set(labsCounter, forKey: "labsCounter")
//          //scroll to last cell that was added
//
//          //scroll to last cell that was added
//
//
//
//
//          //labsCounter += 1
//          //labsCells.append(labsCounter)
//          //UserDefaults.standard.set(labsCounter, forKey: "labsCounter")
//          //To give each patient separated folder in storage using their uid
//          let currentUser = Auth.auth().currentUser!.uid
//          // Create a reference to the file you want to upload
//          let fileRef = storageRef.child("\(currentUser)/labs/lab\(1).pdf")
//
//
//          // Upload the file to the path "docs/rivers.pdf"
//              let uploadTask = fileRef.putFile(from: selectedFileURL, metadata: nil) { metadata, error in
//                guard let metadata = metadata else {
//                  // Uh-oh, an error occurred!
//                  return
//                }
//
//                  self.labsCollectionView.isPagingEnabled = false
//
//                  let indexPath = IndexPath(item: self.labsCells.last!-1, section: 0)
//                  self.labsCollectionView.reloadData()
//                  self.labsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
//
//                  self.labsCollectionView.isPagingEnabled = true
//
//                // Metadata contains file metadata such as size, content-type.
//                let size = metadata.size
//                // You can also access to download URL after upload.
//                  self.storageRef.downloadURL { (url, error) in
//                  guard let downloadURL = url else {
//                    // Uh-oh, an error occurred!
//                      print("fuck no downloand url")
//                    return
//                  }
//
//
//                    print("donwload URL is \(downloadURL)")
//
//                }
//              }
//      }
//}
