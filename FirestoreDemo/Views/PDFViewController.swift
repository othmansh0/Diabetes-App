//
//  PDFViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 6/30/22.
//

import UIKit
import PDFKit
class PDFViewController: UIViewController {
    var pdfURL:URL!
    let pdfView = PDFView()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        print("pdf url is \(pdfURL)")
       
        
        self.pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.frame = view.bounds
        self.view.addSubview(self.pdfView)

        self.pdfView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.pdfView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.pdfView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.pdfView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true


            if let document = PDFDocument(url:pdfURL) {
                self.pdfView.document = document
                self.pdfView.autoScales = true
                self.pdfView.maxScaleFactor = 4.0
                self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit
            }
     
    }
    
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          
      }
      
    


}
