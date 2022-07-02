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
class ChartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIDocumentPickerDelegate {
    
    @IBOutlet var labsCollectionView: UICollectionView!
    @IBOutlet var buttonCollectionView: UICollectionView!
    
    @IBOutlet var collectionViewLayout: CenterViewFlowLayout!
    
    @IBOutlet weak var chart: LineChartView!
    
   
   
    var labsCounter =  UserDefaults.standard.integer(forKey: "labsCounter")
    var labsCells = [Int]()
    
    
    
    // Get a reference to the storage service using the default Firebase App
    //let storage = Storage.storage()
    // Create a storage reference from our storage service
    let storageRef = Storage.storage().reference()
  

  
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
       

        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !labsCells.isEmpty{
        let indexPath = IndexPath(item: labsCells.last!-1, section: 0)
            labsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            
        }
    }
    
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupChart()
        setupChartData()
        
   
    
     }
    
    private func setupChart() {
        let leftAxis = chart.leftAxis
        leftAxis.axisMinimum = -10
        leftAxis.axisMaximum = 100
        leftAxis.granularity = 20
        leftAxis.drawGridLinesEnabled = false
        
        let rightAxis = chart.rightAxis
        rightAxis.enabled = false
        
        let xAxis = chart.xAxis
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 7
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        //xAxis.setLabelCount(7, force: false)
        chart.xAxisRenderer = XAxisWeekRenderer(viewPortHandler: chart.viewPortHandler, xAxis: chart.xAxis, transformer: chart.getTransformer(forAxis: chart.leftAxis.axisDependency))
        xAxis.setLabelCount(7, force: true)
        chart.xAxis.forceLabelsEnabled = true
        chart.xAxis.granularityEnabled = true
        
        
        xAxis.valueFormatter = CustomChartFormatter()
        
        chart.setVisibleXRange(minXRange: 0.0, maxXRange: 7)
        chart.data?.setDrawValues(true)
        
    }
    
    private func setupChartData() {
        var dataEntries: [ChartDataEntry] = []
        
       // let forY: [String] = Patient.sharedInstance.beforeReadings
        //let forX: [String] = Patient.sharedInstance.deltaBeforeTimes
        let forY  = [100,15,25,35,45,55,65]
        let forX = [0,1,2,3,4,5,6]
      
        
        
     
    
        
        
        print("count of y \(forY.count)")
        print("count of x \(forX.count)")
        
//
        
        //print("hereee from chart \(Patient.sharedInstance.beforeReadings)")
        for i in 0..<forY.count {
            if Double(forY[i]) != 0 {
                let dataEntry = ChartDataEntry(x: Double(forX[i]), y: Double(forY[i]))
                dataEntries.append(dataEntry)
            }
            
        }
        let dataSet = LineChartDataSet(entries: dataEntries, label: "")
        let data = LineChartData(dataSet: dataSet)
        chart.data = data
    }
    
    
    
    
    
    
    
    //MARK: Labs CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if labs return labs counter
        if collectionView.tag == 1 {
            return labsCounter}
        return 1 //else return one cell just for add button
    }
    
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
        let indexPath = IndexPath(item: labsCells.last!-1, section: 0)
        labsCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        labsCollectionView.reloadData()

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
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
                self.storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                    print("fuck no downloand url")
                  return
                }
                    
                    
                  print("donwload URL is \(downloadURL)")
                    
              }
            }
    }
}
































