//
//  ReadingCard.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 2/5/22.
//

import Foundation

//
//  PatientViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 11/7/21.
//
import Firebase
import UIKit

class ReadingCard {
    

    
    private var indexOfCellBeforeDragging = 0
    
    public func calculateSectionInset(collectionViewLayout: UICollectionViewFlowLayout) -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 360 + (cellBodyViewIsExpended ? 174 : 0)
        
        let buttonWidth: CGFloat = 79
        
        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
        return inset
    }
    
    public func configureCollectionViewLayoutItemSize(collectionViewLayout: UICollectionViewFlowLayout) {
        let inset: CGFloat = calculateSectionInset(collectionViewLayout: collectionViewLayout) // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
    }
    
    public func indexOfMajorCell(collectionViewLayout: UICollectionViewFlowLayout,readings:[String]) -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(readings.count - 1, index))
        return safeIndex
    }
    
    // ===================================
    // MARK: - UICollectionViewDataSource:
    // ===================================
    
    //cant be refactored
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return beforeReadings.count
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//
//let cell2 = setupCell(collectionView: collectionView, indexPath: indexPath, readings: beforeReadings)
//        return cell2
//
//    }
    

    
    
    
    
    
    func setupCell(collectionView:UICollectionView,indexPath:IndexPath,readings:[String],readingsTime:[String],cellName:String)->CollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! CollectionViewCell
        cell.readingLabel.text = readings[indexPath.row]
        
        //gets time and date from firebase without seconds
        let readingTime = readingsTime[indexPath.row]
        let time1 = readingTime.substring(to: readingsTime[indexPath.row].lastIndex(of: ":")!)
        let time2 = readingTime.substring(from:readingTime.index(readingTime.lastIndex(of: ":")!, offsetBy: 3) )
        let time3 = time1+time2
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "EEEE - hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
               
              
        let englishDate: Date = dateFormatter.date(from: time3)!
        print("english date in collection view is \(englishDate)")
        cell.readingTime.text = getArabicTime(time: englishDate, withSeconds: false)
        
        
        cell.layer.cornerRadius = 15
        //Reverse scrolling direction (right to left)
        collectionView.transform = CGAffineTransform(scaleX:-1,y: 1);
        cell.transform = CGAffineTransform(scaleX:-1,y: 1);
        return cell
    }
    
    
    public func getArabicTime(time:Date,withSeconds:Bool)->String{

           let formatter = DateFormatter()
           formatter.dateStyle = .none
           formatter.timeZone = TimeZone(identifier: "UTC")
           formatter.timeStyle = .short
           //use ar for arabic numbers
           formatter.locale = NSLocale(localeIdentifier: "ar_DZ") as Locale
           formatter.dateFormat = "EEEE - hh:mm:ss a"
           if withSeconds == false {
               formatter.dateFormat = "EEEE -  hh:mm a"
           }
           formatter.amSymbol = "صباحا"
           formatter.pmSymbol = "مساءا"

           let dateString = formatter.string(from: time)
           return dateString
       }
    
}
