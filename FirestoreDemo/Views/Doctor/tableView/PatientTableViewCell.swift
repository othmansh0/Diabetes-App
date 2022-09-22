//
//  PatientTableViewCell.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/21/22.
//

import UIKit

class PatientTableViewCell: UITableViewCell {

    
    @IBOutlet weak var readStatusView: UIView!
    @IBOutlet weak var patientName: UILabel!
    
    @IBOutlet weak var leadingTest: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        readStatusView.makeRounded()
      
    }
    override func layoutSubviews() {
       super.layoutSubviews()

        
        

        }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 40, right: 10))
//    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var k = 10.0
            if let win = window?.frame.width {
                k = round( win * 0.05)
                
                var frame = newValue
                print(k)
                frame.origin.x += k
                
                frame.size.width -= 2 * k

                super.frame = frame
            }
          
          
            
           
         
        }
    }
}
