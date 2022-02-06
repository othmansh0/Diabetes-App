////
////  PatientViewController.swift
////  FirestoreDemo
////
////  Created by othman shahrouri on 11/7/21.
////
//import Firebase
//import UIKit
//
//class Card2ViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
//    
//    
//    var afterReadings = ["1","1","1"]
//    var readingCard = ReadingCard()
//    
//    private var indexOfCellBeforeDragging = 0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        collectionViewLayout.minimumLineSpacing = 5
//        
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        configureCollectionViewLayoutItemSize()
//    }
//    
//    
//   
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return afterReadings.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = readingCard.setupCell(collectionView: collectionView, indexPath: indexPath, readings: afterReadings)
//        return cell
//        
//    }
//
//    
//
//    
// 
//}
//
//extension Card2ViewController {
//    
//    //MARK: Scrolling behaviour
//    private func calculateSectionInset() -> CGFloat {
//        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
//        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
//        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
//        let cellBodyWidth: CGFloat = 360 + (cellBodyViewIsExpended ? 174 : 0)
//        
//        let buttonWidth: CGFloat = 79
//        
//        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
//        return inset
//    }
//    
//    private func configureCollectionViewLayoutItemSize() {
//        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
//        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
//        
//        collectionViewLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewLayout.collectionView!.frame.size.height)
//    }
//    
//    private func indexOfMajorCell() -> Int {
//        let itemWidth = collectionViewLayout.itemSize.width
//        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
//        let index = Int(round(proportionalOffset))
//        let safeIndex = max(0, min(afterReadings.count - 1, index))
//        return safeIndex
//    }
//    
//    
//    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        indexOfCellBeforeDragging = indexOfMajorCell()
//    }
//    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        // Stop scrollView sliding:
//        targetContentOffset.pointee = scrollView.contentOffset
//        
//        // calculate where scrollView should snap to:
//        let indexOfMajorCell = self.indexOfMajorCell()
//        
//        // calculate conditions:
//        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
//        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < afterReadings.count && velocity.x > swipeVelocityThreshold
//        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
//        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
//        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
//        
//        if didUseSwipeToSkipCell {
//            
//            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
//            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
//            
//            // Damping equal 1 => no oscillations => decay animation:
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
//                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
//                scrollView.layoutIfNeeded()
//            }, completion: nil)
//            
//        } else {
//            // This is a much better way to scroll to a cell:
//            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
//            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
//    }
//}
