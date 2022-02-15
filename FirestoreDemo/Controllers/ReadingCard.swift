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
        cell.readingTime.text = readingsTime[indexPath.row]
        
        cell.layer.cornerRadius = 15
        //Reverse scrolling direction (right to left)
        collectionView.transform = CGAffineTransform(scaleX:-1,y: 1);
        cell.transform = CGAffineTransform(scaleX:-1,y: 1);
        return cell
    }
    
    
    
}
