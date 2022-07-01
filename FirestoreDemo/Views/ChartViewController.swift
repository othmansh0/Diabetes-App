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
        print(labsCells)

        }
    
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupChart()
        setupChartData()
        
        print("hey")
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
        xAxis.axisMaximum = 13
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        //xAxis.setLabelCount(7, force: false)
        chart.xAxisRenderer = XAxisWeekRenderer(viewPortHandler: chart.viewPortHandler, xAxis: chart.xAxis, transformer: chart.getTransformer(forAxis: chart.leftAxis.axisDependency))
        xAxis.setLabelCount(7, force: true)
        chart.xAxis.forceLabelsEnabled = true
        chart.xAxis.granularityEnabled = true
        xAxis.valueFormatter = CustomChartFormatter()
        
        chart.setVisibleXRange(minXRange: 0.0, maxXRange: 6.0)
        
        
    }
    
    private func setupChartData() {
        var dataEntries: [ChartDataEntry] = []
        
        let forY: [Double] = [50,60,70,80]
        let forX: [String] = Patient.sharedInstance.beforeTimes

     
        //string to date
//        let now = forX[0]
        //print(now)
        let formatter = DateFormatter()
//        let arabDate = formattedDateFromString(dateString: now, withFormat: "eeee-hh:mm:ss a")
//      print(arabDate)
//        formatter.timeStyle = .short
//        formatter.dateStyle = .short
  //      formatter.dateFormat = "dd/M/y hh:mm:ss a"
//        let date3 = formatter.string(from: now)
        
        
        let date44 = Date()
        
        let newFormatter = DateFormatter()
        newFormatter.dateStyle = .short

        newFormatter.timeStyle = .short
        //use ar for arabic numbers
        newFormatter.locale = NSLocale(localeIdentifier: "ar_DZ") as Locale
       
        //newFormatter.dateFormat = "eeee - hh:mm:ss a dd/M/y"
        newFormatter.dateFormat = "eeee - hh:mm:ss a dd/M/y"
        newFormatter.amSymbol = "صباحا"
        newFormatter.pmSymbol = "مساءا"
        print(newFormatter.string(from: date44))
      
        //print(date3)
        
        //string to date
        let string = "30 October 2019"
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "d MMM y"
        //print(formatter4.date(from: string) ?? "Unknown date")
        
        //date to seconds
        let date = NSDate()
        let unixtime = date.timeIntervalSince1970
//
        
        print("hereee from chart \(Patient.sharedInstance.beforeReadings)")
        for i in 0..<forY.count {
            if Double(forY[i]) != 0 {
                let dataEntry = ChartDataEntry(x: Double(i+1), y: forY[i])
                dataEntries.append(dataEntry)
            }
            
        }
        let dataSet = LineChartDataSet(entries: dataEntries, label: "")
        let data = LineChartData(dataSet: dataSet)
        chart.data = data
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"

        if let date = inputFormatter.date(from: dateString) {

            let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format

            return outputFormatter.string(from: date)
        }

        return nil
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
                  
                  
                  //let vc =  PDFViewController ()
                  //vc.pdfURL = url
                 //self.navigationController?.pushViewController(vc, animated: true)
                                      
//
                  if let vc = self.storyboard?.instantiateViewController(identifier: "detailViewController") as? PDFViewController {
                      vc.pdfURL = url
                                    
                                          self.navigationController?.pushViewController(vc, animated: true)
                                      }
                  
                  
//                  let vc : PDFViewController = PDFViewController()
//                  vc.pdfURL = url
//
//                  //let nv = UINavigationController(rootViewController: vc)
//                  //nv.modalPresentationStyle = .automatic
//                  vc.modalPresentationStyle = .fullScreen
//                  self.present(vc, animated: true)
                  
              
                 
                  
              }
            }
        
        
        
        }
        
        
       // collectionView.reloadData()
        
        
    }
    
    
    
    
    @IBAction func addLabPressed(_ sender: UIButton) {
       
        
        addLabReading()
    }
    
    
    
    
    @objc func addLabReading(){
        print("hey")
        
        
        
       // 1.get access on filesec
        
        
        
        //2.find what func gets called when a file is picked
        //3.
        
        
        // let documentPicker = UIDocumentPickerViewController(documentTypes: [UTTypePlainText as String], in: .import)
         
         let supportedTypes: [UTType] = [UTType.pdf]
         let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
         documentPicker.delegate = self
         documentPicker.allowsMultipleSelection = false
         present(documentPicker, animated: true, completion: nil)
        labsCounter += 1
        labsCells.append(labsCounter)
        UserDefaults.standard.set(labsCounter, forKey: "labsCounter")
        labsCollectionView.reloadData()
         
        
        
        
        
        
        
        
    }
    
    
    @IBAction func writeTest(_ sender: UIButton) {
        
        
//        //for testing purpose write a test file
//
//        let file = "\(UUID().uuidString).text"
//        let contents = "Some random tet"
//
//        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let fileURL = dir.appendingPathComponent(file)
//
//        do {
//            try contents.write(to: fileURL, atomically: false, encoding: .utf8)
//            print("i got ran")
//            }
//        catch {
//            print("error saving testing file ")
//        }
//
//    }
        //To give each patient separated folder in storage using their uid
        let currentUser = Auth.auth().currentUser!.uid
        // Create a reference to the file you want to download
        let fileRef = storageRef.child("\(currentUser)/labs/lab6.pdf")
        
        
       

        // Create local filesystem URL
       // let localURL = URL(string: "Labs/lab\(labsCounter)")!
        
        let tmporaryDirectoryURL = FileManager.default.temporaryDirectory
        let localURL = tmporaryDirectoryURL.appendingPathComponent("lab\(labsCounter).pdf")

        // Download to the local filesystem
        let downloadTask = fileRef.write(toFile: localURL) { url, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Local file URL for "images/island.jpg" is returned
              
              //self.presentActivityViewController(withUrl: url!) (can be used to show activityController ie sharing a file)
              
            


                 
//              
//              
//             
//              self.pdfView.translatesAutoresizingMaskIntoConstraints = false
//              
//              
//              self.view.addSubview(self.pdfView)
//              
//              self.pdfView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//              self.pdfView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//              self.pdfView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
//              self.pdfView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//                  
//
//                  if let document = PDFDocument(url:url!) {
//                      self.pdfView.document = document
//                      self.pdfView.autoScales = true
//                      self.pdfView.maxScaleFactor = 4.0
//                      self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit
//                  }
              
          }
        }
    
    
    
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
































