//
//  ContainerViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/1/22.
//
//to view content of each view
import UIKit

class ContainerViewController: UIViewController{
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuViewController()
    let homeVC = MenuHomeViewController()
    var navVC: UINavigationController?//to nest homevc in nav
    override func viewDidLoad() {
        super.viewDidLoad()
        print("container did load")
        addChildVCs()
    }
    
    private func addChildVCs(){
        
        //Menu
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
     
        
        //Home
//        homeVC.delegate = self
//        let navVC = UINavigationController(rootViewController: ContainerViewController.view)
//        addChild(navVC)
//        view.addSubview(navVC.view)
//        navVC.didMove(toParent: self)
//        self.navVC = navVC
//        navVC.presentDetail(homeVC)
        
        homeVC.delegate = self
        addChild(homeVC)
        view.addSubview(homeVC.view)
        homeVC.didMove(toParent: self)
        presentDetail(homeVC)
       print("hahahahah")
        
    }
   
}


extension ContainerViewController: MenuHomeViewControllerDelegate {
    @objc func didTapMenuButton() {
    
        print("fuck")
        switch menuState{
        case .closed://open menu if opened
            UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: .layoutSubviews) {
                //what code to animate
           
                
              
               
               
                //self.navVC?.view.frame.origin.x = self.view.frame.width / 3
                //self.navVC?.view.frame.origin.x = 60
                //move origin x over
                self.homeVC.view.frame.origin.x = self.homeVC.view.frame.width/2 * 0.8
                //self.homeVC.view.backgroundColor = UIColor(red: 140/255, green: 171/255, blue: 177/255, alpha: 1)
                UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset.init(horizontal: 15, vertical: 0), for: UIBarMetrics.default)
                self.navVC?.navigationItem.rightBarButtonItem?.setTitlePositionAdjustment(UIOffset.init(horizontal: 200, vertical: 200), for: UIBarMetrics.default)
            } completion: { done in
                if done {
                    print("completed")
                 
                }
            }

        case .opened://close menu if closed
            print("hh")
            self.homeVC.isOpen = false
            
        }

        //clos
        //animate menu itself
    }
    
    
    
    
}

extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)

        present(viewControllerToPresent, animated: false)
    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
}
