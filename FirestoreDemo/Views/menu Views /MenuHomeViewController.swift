//
//  HomeViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/1/22.
//

import UIKit
//can add navigation
//sends the view to container view to be viewed

protocol MenuHomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class MenuHomeViewController: UIViewController {

    //weak to avoid memory leak
    weak var delegate: MenuHomeViewControllerDelegate?
    
    var isOpen = true
    var menuBtn = UIButton(type: .custom)
    
    var suggestImage  = UIImage(named: "burgerMenu")!.withRenderingMode(.alwaysOriginal)
    var suggestButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
//isOpen = false
        view.backgroundColor = .blue
        
   navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "burgerMenu"), style: .done, target: self , action: #selector(didTapMenuButton))
//        navigationItem.rightBarButtonItem?.imageInsets =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
        
//        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named:"burgerMenu"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(didTapMenuButton))
//                    rightBarButtonItem.imageInsets = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
//                    //rightBarButtonItem.tintColor = UIColor(hex: 0xED6E19)
//                    self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
//
        
        
        
        
//        menuBtn = UIButton(type: .custom)
//        let backBtnImage = UIImage(named: "burgerMenu")
//        menuBtn.setBackgroundImage(backBtnImage, for: .normal)
//        menuBtn.addTarget(self, action: #selector(didTapMenuButton),for:.touchUpInside)
//        menuBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        view.bounds = view.bounds.offsetBy(dx: 10, dy: 3)
//        view.addSubview(menuBtn)
//        let rightButton = UIBarButtonItem(customView: view)
//        navigationItem.rightBarButtonItem = rightButton
////
        
//        var suggestImage  = UIImage(named: "burgerMenu")!.withRenderingMode(.alwaysOriginal)
//        var suggestButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        suggestButton.setBackgroundImage(suggestImage, for: [])
//        suggestButton.addTarget(self, action: #selector(didTapMenuButton), for:.touchUpInside)
//
//          // here where the magic happens, you can shift it where you like
//        suggestButton.transform = CGAffineTransform(translationX: 10, y: 0)
//
//          // add the button to a container, otherwise the transform will be ignored
//          let suggestButtonContainer = UIView(frame: suggestButton.frame)
//          suggestButtonContainer.addSubview(suggestButton)
//          let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
//
//           //add button shift to the side
//          navigationItem.rightBarButtonItem = suggestButtonItem

    }
    
    


    @objc func didTapMenuButton(){
        //isOpen.toggle()
        //if(isOpen){
         
        UIView.animate(withDuration: 1.5, delay: 3, usingSpringWithDamping: 4, initialSpringVelocity: 4, options: .curveLinear){ [weak self] in
                print("idfc")
                //UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset.init(horizontal: 15, vertical: 0), for: UIBarMetrics.default)

                self?.menuBtn.frame = CGRect(x: -(self?.view.frame.width)!/2 * 0.8 ,y: 0, width: 25, height: 25)
                let view = UIView(frame: CGRect(x: -(self?.view.frame.width)!/2 * 0.8, y: 0, width: 25, height: 25))
                view.bounds = view.bounds.offsetBy(dx: 10, dy: 3)
                view.addSubview(self!.menuBtn)
                let rightButton = UIBarButtonItem(customView: view)
                self?.navigationItem.rightBarButtonItem = rightButton
                
              
                
                
//                self?.suggestImage  = UIImage(named: "burgerMenu")!.withRenderingMode(.alwaysOriginal)
//                self?.suggestButton = UIButton(frame: CGRect(x: 400, y: 0, width: 40, height: 40))
//                self?.suggestButton.setBackgroundImage(self?.suggestImage, for: [])
//                self?.suggestButton.addTarget(self, action: #selector(self?.didTapMenuButton), for:.touchUpInside)
//
//                  // here where the magic happens, you can shift it where you like
//                self?.suggestButton.transform = CGAffineTransform(translationX: 0, y: 0)
//
//                  // add the button to a container, otherwise the transform will be ignored
//                let suggestButtonContainer = UIView(frame: (self?.suggestButton.frame)!)
//                suggestButtonContainer.addSubview(self!.suggestButton)
//                  let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
//
//                  // add button shift to the side
//                self?.navigationItem.rightBarButtonItem = suggestButtonItem

                
            } completion: { done in

            }

            


            
//        } else {
//            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.4, options: .curveEaseOut){ [weak self] in
//                self?.menuBtn.frame = CGRect(x: 0 ,y: 0, width: 25, height: 25)
//                let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//                view.bounds = view.bounds.offsetBy(dx: 10, dy: 3)
//                view.addSubview(self!.menuBtn)
//                let rightButton = UIBarButtonItem(customView: view)
//                self?.navigationItem.rightBarButtonItem = rightButton
//            } completion: { done in
//
//            }
//
//        }
        //call the delegate function
        delegate?.didTapMenuButton()
    }

}
