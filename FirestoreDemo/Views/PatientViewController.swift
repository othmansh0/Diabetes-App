//
//  PatientViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 11/7/21.
//
import Firebase
import UIKit

class PatientViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionViewTwo: UICollectionView!
    @IBOutlet weak var collectionViewOne: UICollectionView!
    @IBOutlet private weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionViewLayout2: UICollectionViewFlowLayout!
    //  @IBOutlet weak var collectionViewLayout2: UICollectionViewFlowLayout!
    
    var beforeReadings = ["1","2","3","4","5","6","7"]
    var afterReadings = ["1","2","3","4"]
    var readingCard = ReadingCard()
    
    private var indexOfCellBeforeDragging = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout2.minimumLineSpacing = 5
        collectionViewOne.tag = 1
        collectionViewTwo.tag = 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayoutItemSize(collectionViewLayout: collectionViewLayout)
        configureCollectionViewLayoutItemSize(collectionViewLayout: collectionViewLayout2)
    }
    
    
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
        let inset: CGFloat = calculateSectionInset(collectionViewLayout: collectionViewLayout) // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
    }
    
    private func indexOfMajorCell(collectionViewLayout:UICollectionViewFlowLayout) -> Int {
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(beforeReadings.count - 1, index))
        return safeIndex
    }
    
    // ===================================
    // MARK: - UICollectionViewDataSource:
    // ===================================
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewTwo {
            return afterReadings.count
        }
        
        return beforeReadings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsPaletteCollectionViewCell", for: indexPath) as! ColorsPaletteCollectionViewCell
//
//        cell.configure(colors: readings[indexPath.row]) { (selectedColor: UIColor) in
//            self.view.backgroundColor = selectedColor
//        }
//
//        // You can color the cells so you could see how they behave:
//        //        let isEvenCell = CGFloat(indexPath.row).truncatingRemainder(dividingBy: 2) == 0
//        //        cell.backgroundColor = isEvenCell ? UIColor(white: 0.9, alpha: 1) : .white
//
//        return cell

        
        
        if collectionView == collectionViewTwo {
            let cell2 = readingCard.setupCell(collectionView: collectionView, indexPath: indexPath, readings: afterReadings,cellName: "Cell2")
            return cell2
        }
        let cell = readingCard.setupCell(collectionView: collectionView, indexPath: indexPath, readings: beforeReadings,cellName: "Cell")
        
        return cell
        
    }

    

    
 
}

extension PatientViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == 2 {
            indexOfCellBeforeDragging = indexOfMajorCell(collectionViewLayout: collectionViewLayout2)
            print("hey2")
        } else {
            print("hey1")
        indexOfCellBeforeDragging = indexOfMajorCell(collectionViewLayout: collectionViewLayout)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        var indexOfMajorCell = self.indexOfMajorCell(collectionViewLayout: collectionViewLayout)
        if scrollView.tag == 2 {
             indexOfMajorCell = self.indexOfMajorCell(collectionViewLayout: collectionViewLayout2)
        }
        
        
       
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        var hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < beforeReadings.count && velocity.x > swipeVelocityThreshold
        if scrollView.tag == 2 {
             hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < afterReadings.count && velocity.x > swipeVelocityThreshold
        }
        
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            var toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            if scrollView.tag == 2 {
                toValue = collectionViewLayout2.itemSize.width * CGFloat(snapToIndex)
            }
            
             
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            // This is a much better way to scroll to a cell:
            
            if scrollView.tag == 2 {
                let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
                collectionViewLayout2.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            else {
                let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
                collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
           
        }
    }
}
