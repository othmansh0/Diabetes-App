//
//  DoctorLabsViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/24/22.
//

import UIKit
import Firebase
import FirebaseStorage

class DoctorLabsViewController: UIViewController {
    
    @IBOutlet weak var labsCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewTopCons: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.title = "المختبرات"
        labsCollectionView.reloadData()
        print("labs in labs view  \(labs)")
    }
    
    var labs = [String]()
    var userID = ""
    let storageRef = Storage.storage().reference()

    var flagy = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("flagy is \(flagy)")
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 245/255, alpha: 1)
        navigationBarAppearance.backgroundColor = UIColor(red: 235/255, green: 240/255, blue: 240/255, alpha: 1)
        navigationItem.title = "المختبرات"
        
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor(red: 91/255, green: 122/255, blue: 128/255, alpha: 1),NSAttributedString.Key.font: UIFont(name: "Arial", size: 22.0)]
        //navigationItem.largeTitleDisplayMode = .always
        //navigationController!.navigationBar.titleTextAttributes = []
        
        
        //navigationController?.title = "المختبرات"
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.isHiddenHairline = true
        labsCollectionView.delegate = self
        labsCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        if let layout = labsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            let val1 = view.frame.width * 0.02564103
            layout.minimumLineSpacing = val1
            layout.minimumInteritemSpacing = val1
            let val4 = view.frame.height * 0.00592417
            layout.sectionInset = UIEdgeInsets(top: val4, left: val1, bottom: val4, right:val1)
            var val2 = view.frame.width * 0.33333333
            if(view.frame.width > 390){//iphone max
                val2 = view.frame.width * 0.22
            }
            
            let val3 = view.frame.height * 0.21327014
            let size = CGSize(width:(labsCollectionView!.bounds.width-val2)/2, height: val3)
            
            layout.itemSize = size
        }
    }
    
    
    
    
}

extension DoctorLabsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labReading", for: indexPath) as? LabCell{
            cell.layer.cornerRadius = 15
            var labReadingNum = labs[indexPath.item].replacingOccurrences(of: "lab", with: "")
            labReadingNum = labReadingNum.replacingOccurrences(of: ".pdf", with: "")
            cell.labReadingLabel.text = "مختبر \(labReadingNum)"
            return cell
        }
       
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let child = SpinnerViewController()
        //
        //                   // add the spinner view controller
                        self.addChild(child)
                        child.view.frame = self.view.frame
                        self.view.addSubview(child.view)
                       child.didMove(toParent: self)
        
        let currentUser = userID
                    // Create a reference to the file you want to download
                    let fileRef = storageRef.child("\(currentUser)/labs/\(labs[indexPath.item])")
                    
                    // Create local filesystem URL
                    let tmporaryDirectoryURL = FileManager.default.temporaryDirectory
                    let localURL = tmporaryDirectoryURL.appendingPathComponent("\(labs[indexPath.item])")

                    // Download to the local filesystem
                    let downloadTask = fileRef.write(toFile: localURL) { url, error in
                      if let error = error {
                        // Uh-oh, an error occurred!
                          self.alert(message: error.localizedDescription)
                      } else {
                        // Local file URL for "images/island.jpg" is returned
                          
                          //self.presentActivityViewController(withUrl: url!) (can be used to show activityController ie sharing a file)
                          
                          //Shows pdf in a detailView so it can get navBar
                          child.willMove(toParent: nil)
                                   child.view.removeFromSuperview()
                                   child.removeFromParent()
                                   
                            
                          if let vc = self.storyboard?.instantiateViewController(identifier: "detailViewController") as? PDFViewController {
                              vc.pdfURL = url
                               self.navigationController?.pushViewController(vc, animated: true)
                                              }
                        
                      }
                    }
    }
}

