//
//  ChartViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 2/24/22.
//

import UIKit
import Charts
import MobileCoreServices
import UniformTypeIdentifiers
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PDFKit
class ChartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIDocumentPickerDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var labsCollectionView: UICollectionView!
    @IBOutlet var buttonCollectionView: UICollectionView!
    
    @IBOutlet var collectionViewLayout: CenterViewFlowLayout!
    
    @IBOutlet weak var chart: LineChartView!
    
    @IBOutlet weak var weeksLabel: UILabel!
    
   
    var labsCounter =  UserDefaults.standard.integer(forKey: "labsCounter")
    var labsCells = [Int]()
    
    
    
    // Get a reference to the storage service using the default Firebase App
    //let storage = Storage.storage()
    // Create a storage reference from our storage service
    let storageRef = Storage.storage().reference()
    
    
    let db = Firestore.firestore()
    var docs: [QueryDocumentSnapshot]!
    var numberOfweeks: Int!
    var weekIndex = 0 //latest week
    //let weeksRef = db.collection("cities")
    var weeksIDS = [String]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        labsCollectionView.delegate = self
        labsCollectionView.dataSource = self
        buttonCollectionView.delegate = self
        buttonCollectionView.dataSource = self
        labsCollectionView.tag = 1
        buttonCollectionView.tag = 2
       
        if  labsCounter != 0 {
            for lab in 1...labsCounter {
                labsCells.append(lab)
            }
        }
       
        print("my docID IS\(Patient.sharedInstance.doctorID!)")
        let weeksRef = db.collection("doctors").document(Patient.sharedInstance.doctorID!).collection("patients").document(Auth.auth().currentUser!.uid).collection("weeks")


        weeksRef.getDocuments { [self] snap, erorr in
            self.docs = snap?.documents
            //reversing documents to view weeks from newest to oldest
            self.docs?.reverse()
            self.numberOfweeks = self.docs?.count
            
            //remove week from weeks id
            for doc in self.docs!{
                var docID = doc.documentID
                if let range = docID.range(of: "week") {
                   docID.removeSubrange(range)
                }
                //save week ids in array to update weeks label under chart
                //self.weeksIDS.append(docID)
                print("doc id is \(docID)")
                weeksIDS.append(docID)
            }
           // print(docs?[0].data()["afterTimes"] as? [String])
        }

        
        weeksLabel.text = "أسبوع \(Patient.sharedInstance.weeksCount!)"
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !labsCells.isEmpty{
            labsCollectionView.isPagingEnabled = false
        let indexPath = IndexPath(item: labsCells.last!-1, section: 0)
            labsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            
        }
        labsCollectionView.isPagingEnabled = true
    }
    
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupChart(chart: chart)
        setupChartData(beforeReadings: Patient.sharedInstance.beforeReadings, deltaBeforeTimes: Patient.sharedInstance.deltaBeforeTimes, afterReadings: Patient.sharedInstance.afterReadings, deltaAfterTimes: Patient.sharedInstance.deltaAfterTimes)
        
     }
    
    public func setupChart(chart:LineChartView) {
        let leftAxis = chart.leftAxis
        leftAxis.axisMinimum = -10
        leftAxis.axisMaximum = 100
        leftAxis.granularity = 20
        leftAxis.labelTextColor = UIColor(red: 133/255, green: 179/255, blue: 187/255, alpha: 1)
        leftAxis.axisLineColor = UIColor(red: 91/255, green: 122/255, blue: 128/255, alpha: 0.08)
        leftAxis.drawAxisLineEnabled = false
        leftAxis.axisLineWidth = 1.5
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridColor = UIColor(red: 91/255, green: 122/255, blue: 128/255, alpha: 0.08)
        leftAxis.gridLineWidth = 1.5
        
        let rightAxis = chart.rightAxis
        rightAxis.enabled = false
        
        let xAxis = chart.xAxis
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 7
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = UIColor(red: 133/255, green: 179/255, blue: 187/255, alpha: 1)

        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.axisLineColor = UIColor(red: 91/255, green: 122/255, blue: 128/255, alpha: 0.08)
        xAxis.axisLineWidth = 1.5
        //xAxis.setLabelCount(7, force: false)
        chart.xAxisRenderer = XAxisWeekRenderer(viewPortHandler: chart.viewPortHandler, xAxis: chart.xAxis, transformer: chart.getTransformer(forAxis: chart.leftAxis.axisDependency))
        xAxis.setLabelCount(7, force: true)
        chart.xAxis.forceLabelsEnabled = true
        chart.xAxis.granularityEnabled = true
        
        
        xAxis.valueFormatter = CustomChartFormatter()
        
        
        
        chart.setVisibleXRange(minXRange: 0.0, maxXRange: 7)
        chart.data?.setDrawValues(true)
        //chart.legend.xOffset = (chart.window?.frame.width)! * 0.42
        chart.legend.form = .circle
        chart.extraTopOffset = 20
       
        chart.legend.horizontalAlignment = .center
        chart.legend.verticalAlignment = .top
        chart.extraBottomOffset = 50
    }
    
    
    public func setupChartData(beforeReadings:[String],deltaBeforeTimes:[String],afterReadings:[String],deltaAfterTimes:[String]) {
        var lineChartEntry1: [ChartDataEntry] = []//before eatting
        var lineChartEntry2: [ChartDataEntry] = [] //after eatting
        
        let forY: [String] = beforeReadings
        let forX: [String] = deltaBeforeTimes
        
//        let forY2 = [100,100,25,15,12,55,65]
//        let forX2 = [0.5,0.7,2,3,4,5,6]
//
        let forY2 = afterReadings
        let forX2 = deltaAfterTimes
        
        
       // let forY  = [100,100,25,15,12,55,65]
        //let forX = [0.5,0.7,2,3,4,5,6]
      
        let data = LineChartData()
        
     
    
        
        
        print("count of y \(forY.count)")
        print("count of x \(forX.count)")
        
//
        
        //print("hereee from chart \(Patient.sharedInstance.beforeReadings)")
        
        for i in 0..<forY.count { //before eatting
            if Double(forY[i]) != 0 {
                let dataEntry = ChartDataEntry(x: Double(forX[i])!, y: Double(forY[i])!)
                lineChartEntry1.append(dataEntry)
            }
            
        }
        
        for i in 0..<forY2.count {//after eatting
            if Double(forY2[i]) != 0 {
                let dataEntry = ChartDataEntry(x: Double(forX2[i])!, y: Double(forY2[i])!)
                lineChartEntry2.append(dataEntry)
            }
            
        }
        
        let dataSet = LineChartDataSet(entries: lineChartEntry1, label: "قبل الأكل")
        
        let dataSet2 = LineChartDataSet(entries: lineChartEntry2, label: "بعد الأكل")
        
        data.addDataSet(dataSet)
        data.addDataSet(dataSet2)
        //before eating line design
        dataSet.setColor(UIColor(red: 187/255, green: 214/255, blue: 197/255, alpha: 1))
        dataSet.fillColor = .white
        dataSet.circleColors = [UIColor(red: 187/255, green: 214/255, blue: 197/255, alpha: 1)]
        dataSet.circleRadius = 6
        dataSet.lineWidth = 3
        
        
        dataSet2.setColor(UIColor(red: 52/255, green: 91/255, blue: 99/255, alpha: 1))
        dataSet2.fillColor = .white
        dataSet2.circleColors = [UIColor(red: 52/255, green: 91/255, blue: 99/255, alpha: 1)]
        dataSet2.circleRadius = 6
        dataSet2.lineWidth = 3
        
        
        chart.data = data
        
        //chart.legend.horizontalAlignment = .center
    }
    
    
    
    
    
    
    
    //MARK: Labs CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if labs return labs counter
        if collectionView.tag == 1 {
            return labsCounter}
        return 1 //else return one cell just for add button
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let height = view.frame.size.height
//        let width = view.frame.size.width
//        // in case you you want the cell to be 40% of your controllers view
//        return CGSize(width: width * 0.2, height: height * 0.3)
//    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath)
            cell.layer.cornerRadius = 15
            //Button frame design
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor(red: 218/255, green: 228/255, blue: 229/255, alpha: 1).cgColor
            
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labReading", for: indexPath) as? LabCell else {
            fatalError("Unable to deuque PersonCell")
        }
        
        collectionView.transform = CGAffineTransform(scaleX:-1,y: 1);
        cell.transform = CGAffineTransform(scaleX:-1,y: 1);
        
        
        
        let labReadingNum = labsCells[indexPath.item]
        cell.labReadingLabel.text = "\(labReadingNum)مختبر"
        
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2 {
            addLabReading()
            
           
        }
        else {//labs collection view clicked
            let currentUser = Auth.auth().currentUser!.uid
            // Create a reference to the file you want to download
            let fileRef = storageRef.child("\(currentUser)/labs/lab\(labsCells[indexPath.item]).pdf")
            
            // Create local filesystem URL
            let tmporaryDirectoryURL = FileManager.default.temporaryDirectory
            let localURL = tmporaryDirectoryURL.appendingPathComponent("lab\(labsCounter).pdf")

            // Download to the local filesystem
            let downloadTask = fileRef.write(toFile: localURL) { url, error in
              if let error = error {
                // Uh-oh, an error occurred!
              } else {
                // Local file URL for "images/island.jpg" is returned
                  
                  //self.presentActivityViewController(withUrl: url!) (can be used to show activityController ie sharing a file)
                  
                  //Shows pdf in a detailView so it can get navBar
                  if let vc = self.storyboard?.instantiateViewController(identifier: "detailViewController") as? PDFViewController {
                      vc.pdfURL = url
                       self.navigationController?.pushViewController(vc, animated: true)
                                      }
                
              }
            }
        
        
        
        }
        
        
       // collectionView.reloadData()
        
        
    }
    
    
    
  
    
    
    
    
    @objc func addLabReading(){
        // let documentPicker = UIDocumentPickerViewController(documentTypes: [UTTypePlainText as String], in: .import)
         
         let supportedTypes: [UTType] = [UTType.pdf]
         let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
         documentPicker.delegate = self
         documentPicker.allowsMultipleSelection = false
         present(documentPicker, animated: true, completion: nil)
       
    }
    
    
    
    
    
    @IBAction func navigateChartPressed(_ sender: UIButton) {
  
        //next then weekIndex--
        //back then weekIndex++
        
        if sender.tag == 1 && weekIndex-1 >= 0 {//next button clicked
            weekIndex -= 1
            weeksLabel.text = "أسبوع \(weeksIDS[weekIndex])"
        }
        else if sender.tag == 2 && weekIndex+1 < numberOfweeks {//back button pressed
            weekIndex += 1
            weeksLabel.text = "أسبوع \(weeksIDS[weekIndex])"
            
        }
        else {//do nothing
            return
        }
        
        
        
        var afterTimes = docs?[weekIndex].data()["afterTimes"] as? [String]
        //fetch arrays from firebase
        var afterReadings = docs?[weekIndex].data()["afterReadings"] as? [String] ?? ["error fetching array from firebase"]

        var deltaAfterTimes = docs?[weekIndex].data()["deltaAfterTimes"] as? [String] ?? ["error fetching array from firebase"]
        
        var beforeTimes = docs?[weekIndex].data()["beforeTimes"] as? [String]
        //fetch arrays from firebase
        var beforeReadings = docs?[weekIndex].data()["beforeReadings"] as? [String] ?? ["error fetching array from firebase"]

        var deltaBeforeTimes = docs?[weekIndex].data()["deltaBeforeTimes"] as? [String] ?? ["error fetching array from firebase"]
        
            setupChartData(beforeReadings: beforeReadings, deltaBeforeTimes: deltaBeforeTimes, afterReadings: afterReadings, deltaAfterTimes: deltaAfterTimes)
          
    }
    
    
    
}





extension ChartViewController {
    
    //can be used to show activityController
//    func presentActivityViewController(withUrl url: URL) {
//        DispatchQueue.main.async {
//          let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//          activityViewController.popoverPresentationController?.sourceView = self.view
//          self.present(activityViewController, animated: true, completion: nil)
//        }
//    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      
        
        guard let selectedFileURL = urls.first else {
            return
        }
        
        print("upload to firebase")
        //placed here so if a user doesnt add a file an empty lab cell wont be added
        labsCounter += 1
        labsCells.append(labsCounter)
        UserDefaults.standard.set(labsCounter, forKey: "labsCounter")
        //scroll to last cell that was added
  
        //scroll to last cell that was added
            
        
        
        
        //labsCounter += 1
        //labsCells.append(labsCounter)
        //UserDefaults.standard.set(labsCounter, forKey: "labsCounter")
        //To give each patient separated folder in storage using their uid
        let currentUser = Auth.auth().currentUser!.uid
        // Create a reference to the file you want to upload
        let fileRef = storageRef.child("\(currentUser)/labs/lab\(labsCounter).pdf")

        
        // Upload the file to the path "docs/rivers.pdf"
            let uploadTask = fileRef.putFile(from: selectedFileURL, metadata: nil) { metadata, error in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
                
                self.labsCollectionView.isPagingEnabled = false
                
                let indexPath = IndexPath(item: self.labsCells.last!-1, section: 0)
                self.labsCollectionView.reloadData()
                self.labsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
             
                self.labsCollectionView.isPagingEnabled = true

              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
//                self.storageRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                  // Uh-oh, an error occurred!
//                    print("fuck no downloand url")
//                  return
//                }
//                    
//                    
//                  print("donwload URL is \(downloadURL)")
//                    
//              }
            }
    }
}
































