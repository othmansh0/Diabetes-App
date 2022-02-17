//
//  baseVC.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 2/17/22.
//
import UIKit
class BaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    public func getArabicTime(time:Date,withSeconds:Bool)->String{

        let formatter = DateFormatter()
        formatter.dateStyle = .none

        formatter.timeStyle = .short
        //use ar for arabic numbers
        formatter.locale = NSLocale(localeIdentifier: "ar_DZ") as Locale
        formatter.dateFormat = "EEEE -  hh:mm:ss a"
        if withSeconds == false {
            formatter.dateFormat = "EEEE -  hh:mm a"
        }
        formatter.amSymbol = "صباحا"
        formatter.pmSymbol = "مساءا"

        let dateString = formatter.string(from: time)
        return dateString
    }
    
}
