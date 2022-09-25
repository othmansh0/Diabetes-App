//
//  PatientDetailViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/23/22.
//

import UIKit
import Charts
class PatientDetailViewController: UIViewController {
    var isPushing = false
    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var weeksLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var cardView: UIView!
    let beforeReadings = ["1"]
    let beforeTimes = ["Tuesday - 04:54:22 PM"]
    let deltaBeforeTimes = ["2.7914186046511626"]
    
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    @IBOutlet weak var weeksLabelBtmCon: NSLayoutConstraint!
    @IBOutlet weak var chaetBtmConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewTopCons: NSLayoutConstraint!
    @IBOutlet weak var textViewBtmCons: NSLayoutConstraint!
    let afterReadings = ["90","2"]
    let afterTimes = ["Tuesday - 04:54:24 PM","Tuesday - 04:55:08 PM"]
    let deltaAfterTimes = ["2.791953488372093","2.7914418604651163"]
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor(red: 241/255, green: 245/255, blue: 245/255, alpha: 1)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.isHiddenHairline = true
        
        //historyTextView.isSecureTextEntry = true
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @objc func sayHey(){
        print("hey labs")
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DoctorLabs") as? DoctorLabsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "المختبرات", style: .plain, target: self, action: #selector(sayHey))
        //remove back word from navigation button item for next view
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        historyTextView.text = " \u{2022} " + historyTextView.text
        
        let beforeColor = UIColor(red: 133/255, green: 165/255, blue: 171/255, alpha: 1)
        let afterColor = UIColor(red: 255/255, green: 213/255, blue: 159/255, alpha: 1)
        let axisColor = beforeColor
        let labelColor = UIColor(red: 133/255, green: 179/255, blue: 187/255, alpha: 1)
        Patient.sharedInstance.setupChart(chart: lineChart, beforeColor: beforeColor, afterColor: afterColor, axisColor: axisColor, labelColor: labelColor)
        Patient.sharedInstance.setupChartData(chart: lineChart, beforeReadings: beforeReadings, deltaBeforeTimes: deltaBeforeTimes, afterReadings: afterReadings, deltaAfterTimes: deltaAfterTimes,beforeColor:beforeColor,afterColor: afterColor,axisColor: axisColor)
        
        
        chaetBtmConstraint.constant = view.frame.height * 0.52725118
        
        weeksLabelBtmCon.constant = view.frame.height * -0.02725118
        print("height is \(view.frame.height)")
        
        textViewTopCons.constant = view.frame.height * 0.1528436
        textViewBtmCons.constant = view.frame.height * 0.06635071
        
        cardHeight.constant = view.frame.height * 0.53909953
        //cardHeight.constant = -400
        cardView.layer.cornerRadius = 40
        
        historyTextView.delegate = self
        historyTextView.layer.cornerRadius = 15
        historyTextView.layer.borderColor = UIColor(red: 133/255, green: 165/255, blue: 171/255, alpha: 0.3).cgColor
        historyTextView.layer.borderWidth = 2
    }
    
    
    
    
}
extension PatientDetailViewController:UITextViewDelegate{
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard navigationController?.topViewController == self else { return }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "historyDetail") as? HistoryDetailViewController {
            vc.delegate = self
            
            //To start on new line if history is not empty
            if historyTextView.text != "\u{2022}" && historyTextView.text.last != " "{
                vc.historytext = historyTextView.text + "\n \n \n \u{2022} "
            }
            else {
                vc.historytext = historyTextView.text
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}



extension PatientDetailViewController:TakingHistroyDelegate{
    func finishedTakingHistroy(text: String) {
        historyTextView.text = text
    }
}

extension UINavigationController {
    
    var isHiddenHairline: Bool {
        get {
            guard let hairline = findHairlineImageViewUnder(navigationBar) else { return true }
            return hairline.isHidden
        }
        set {
            if let hairline = findHairlineImageViewUnder(navigationBar) {
                hairline.isHidden = newValue
            }
        }
    }
    
    private func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        
        return nil
    }
    
    
}
