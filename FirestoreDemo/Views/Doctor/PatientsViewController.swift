//
//  PatientsViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/20/22.
//

import UIKit

class PatientsViewController: UIViewController{
   
    
    @IBOutlet weak var patientsTableView: UITableView!
   
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.patientsTableView.delegate = self
        self.patientsTableView.dataSource = self
        // Do any additional setup after loading the view.
        patientsTableView.rowHeight = 90
        print("height is \(view.frame.height * 0.17)")
        tableViewHeight.constant = view.frame.height * 0.2
      //  patientsTableView.translatesAutoresizingMaskIntoConstraints = false
        //patientsTableView.contentInset = .init(top: 0.0, left: 23.5, bottom: 0.0, right: 23.5)
        //patientsTableView.layoutMargins = .init(top: 0.0, left: 23.5, bottom: 0.0, right: 23.5)
        

        
        
        patientsTableView.register(UINib(nibName: "PatientTableViewCell", bundle: nil), forCellReuseIdentifier: "patientCell")
       // patientsTableView.layoutMargins = .init(top: 0.0, left: 40, bottom: 0.0, right: 40)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    

}


//MARK: table view methods
extension PatientsViewController:UITableViewDataSource,UITableViewDelegate {
    //var data = ["beforeButton","afterButo"]
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath) as? PatientTableViewCell {
          //  cell.layer.cornerRadius = 40
            //cell.patientName.text = "haha"
           
         
            return cell
        }
        return UITableViewCell()
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell got selected")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 15    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        
       

        //cell.contentView.layoutMargins =
    }

    
}
extension UIView {
    
    func makeRounded() {
        
        //layer.borderWidth = 1
        layer.masksToBounds = false
        //layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
