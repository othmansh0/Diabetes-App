//
//  PatientsViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/20/22.
//

import UIKit

class PatientsViewController: UIViewController{
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var patientsTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!

    
    @IBOutlet weak var searchBarTrailing: NSLayoutConstraint!
    @IBOutlet weak var searchBarLeading: NSLayoutConstraint!
    
    
    let names = ["othman","ahmad","samer","layla nemer","fathi","laya dad"]
    var filteredNames = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       filteredNames = names
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        let navigationBarAppearance = UINavigationBarAppearance()
                       navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(red: 218/255, green: 228/255, blue: 229/255, alpha: 0.3)
                       navigationBarAppearance.titleTextAttributes = [
                           NSAttributedString.Key.foregroundColor : UIColor.red
                       ]
       
                     UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                      UINavigationBar.appearance().compactAppearance = navigationBarAppearance
                      UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        navigationItem.title = "fdfd"
       
        
        self.patientsTableView.delegate = self
        self.patientsTableView.dataSource = self
        searchBar.delegate = self
        
        
        searchBar.layer.cornerRadius = 10
        //searchBar.layer.frame.size = CGSize(width: 100, height: 200)
        searchBar.updateHeight(height: 150,radius: 5)
        searchBarLeading.constant = patientsTableView.frame.width * 0.1
        searchBarTrailing.constant = patientsTableView.frame.width * 0.1
       
        let searchTextField:UITextField = searchBar.value(forKey: "searchField") as? UITextField ?? UITextField()
        searchTextField.textAlignment = NSTextAlignment.right
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "بحث",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        let searchIcon = UIImage(systemName: "magnifyingglass")!.withTintColor(.white, renderingMode: .alwaysOriginal)
        let imageView:UIImageView = UIImageView.init(image: searchIcon)
        //searchTextField.leftView = nil
        searchTextField.leftView = imageView
        //searchTextField.placeholder.cg
        patientsTableView.rowHeight = 90
        print("height is \(view.frame.height * 0.17)")
        tableViewHeight.constant = view.frame.height * 0.2
        
        patientsTableView.register(UINib(nibName: "PatientTableViewCell", bundle: nil), forCellReuseIdentifier: "patientCell")
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        let searchIcon = UIImage(systemName: "magnifyingglass")!.withTintColor(.white, renderingMode: .alwaysOriginal)
//
//        let searchTextField:UITextField = searchBar.value(forKey: "searchField") as? UITextField ?? UITextField()
//                searchTextField.layer.cornerRadius = 15
//                searchTextField.textAlignment = NSTextAlignment.right
//     //   searchTextField.placeholder.
//               // let image:UIImage = UIImage(named: "search")!
//        let imageView:UIImageView = UIImageView.init(image: searchIcon)
//              //  searchTextField.leftView = nil
//                 //searchTextField.font = UIFont.textFieldText
//               // searchTextField.attributedPlaceholder = NSAttributedString(string: placeHolderText,attributes: [NSAttributedString.Key.foregroundColor: UIColor.yourCOlur])
//                searchTextField.rightView = imageView
//                //searchTextField.backgroundColor = UIColor.yourCOlur
//        searchTextField.textAlignment = .right
//
//        searchTextField.placeholder = "بحث"
//                searchTextField.rightViewMode = UITextField.ViewMode.always
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
        return filteredNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath) as? PatientTableViewCell {
          //  cell.layer.cornerRadius = 40
            //cell.patientName.text = "haha"
            cell.patientName.text = filteredNames[indexPath.row]
         
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

extension PatientsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNames = []
        
        if searchText.isEmpty {
            filteredNames = names
            patientsTableView.reloadData()
        }
        for name in names {
          
            if name.uppercased().contains(searchText.uppercased()) == true {
                filteredNames.append(name)
                patientsTableView.reloadData()
            }
                //else {
//                filteredNames = []
//                patientsTableView.reloadData()
//            }
            
        }
       
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
     
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredNames = names
        patientsTableView.reloadData()
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

extension UISearchBar {
    func updateHeight(height: CGFloat, radius: CGFloat = 8.0) {
        let image: UIImage? = UIImage.imageWithColor(color: UIColor.clear, size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        for subview in self.subviews {
            for subSubViews in subview.subviews {
                if #available(iOS 13.0, *) {
                    for child in subSubViews.subviews {
                        if let textField = child as? UISearchTextField {
                            textField.layer.cornerRadius = radius
                            textField.clipsToBounds = true
                        }
                    }
                    continue
                }
                if let textField = subSubViews as? UITextField {
                    textField.layer.cornerRadius = radius
                    textField.clipsToBounds = true
                }
            }
        }
    }
}

private extension UIImage {
    static func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
}
