//
//  DoctorLabsViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/24/22.
//

import UIKit

class DoctorLabsViewController: UIViewController {
    
    @IBOutlet weak var labsCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewTopCons: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.title = "المختبرات"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labReading", for: indexPath)
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    
}
