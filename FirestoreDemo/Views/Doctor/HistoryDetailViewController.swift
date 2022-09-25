//
//  HistoryDetailViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/23/22.
//

import UIKit
protocol TakingHistroyDelegate {
    func finishedTakingHistroy(text:String)
}
class HistoryDetailViewController: UIViewController,UITextViewDelegate,UINavigationControllerDelegate {
    
    
    var delegate: TakingHistroyDelegate?
    
    @IBOutlet weak var fullHistroyTextView: UITextView!
    var historytext:String!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fullHistroyTextView.delegate = self
        fullHistroyTextView.text = historytext
        fullHistroyTextView.becomeFirstResponder()
        
        
        navigationController?.delegate = self
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor(red: 218/255, green: 229/255, blue: 218/255, alpha: 0.37)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor(red: 91/255, green: 122/255, blue: 128/255, alpha: 1),NSAttributedString.Key.font: UIFont(name: "Arial", size: 22.0) ]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        navigationItem.title = "السجل"
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.finishedTakingHistroy(text: fullHistroyTextView.text)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //
        // If the replacement text is "\n" and the
        // text view is the one you want bullet points
        // for
        if(range.location == 0){
            fullHistroyTextView.text += "\u{2022}"
        }
        if (text == "\n") {
            // If the replacement text is being added to the end of the
            // text view, i.e. the new index is the length of the old
            // text view's text...
            
            
            if range.location == textView.text.count {
                // Simply add the newline and bullet point to the end
                let updatedText: String = textView.text! + "\n \n \n \u{2022} "
                textView.text = updatedText
            }
            else {
                
                // Get the replacement range of the UITextView
                let beginning: UITextPosition = textView.beginningOfDocument
                
                let start: UITextPosition = textView.position(from: beginning, offset: range.location)!
                let end: UITextPosition = textView.position(from: start, offset: range.length)!
                
                let textRange: UITextRange = textView.textRange(from: start, to: end)!
                // Insert that newline character *and* a bullet point
                // at the point at which the user inputted just the
                // newline character
                textView.replace(textRange, withText: "\n \n \n \u{2022} ")
                // Update the cursor position accordingly
                let cursor: NSRange = NSMakeRange(range.location + "\n \n \n \u{2022} ".count, 0)
                textView.selectedRange = cursor
            }
            
            return false
            
            
        }
        // Else return yes
        return true
    }
    
    
}
