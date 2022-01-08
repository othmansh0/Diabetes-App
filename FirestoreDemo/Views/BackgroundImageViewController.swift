//
//  BackgroundImageViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 1/3/22.
//

import UIKit

class BackgroundImageViewController: UIViewController {
    
     func viewDidLoad(_animated: Bool) {
        super.viewDidLoad()
       let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
       backgroundImage.image = UIImage(named: "greenBG")
         backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
       self.view.insertSubview(backgroundImage, at: 0)
     }

   }
