//
//  PatientsViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/20/22.
//

import UIKit
import Firebase
class PatientsViewController: UIViewController{
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var patientsTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var searchBarTrailing: NSLayoutConstraint!
    @IBOutlet weak var searchBarLeading: NSLayoutConstraint!
    
    
    @IBOutlet weak var navBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var drPersonBtm: NSLayoutConstraint!
    
    @IBOutlet weak var doctorName: UILabel!
    
    //Side Menu
   
    @IBAction open func revealSideMenu2() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    
    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    private var revealSideMenuOnTop: Bool = true
    
    private var sideMenuShadowView: UIView!
    
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    
    
    var userName = "othman "
    var docGovID = "1234"
    var nationalID = "1234"
    let defaults = UserDefaults.standard
    var doctorID: String!
    
    let names = Patients.sharedInstance.names
    let patientsID = Patients.sharedInstance.patientsID
    var filteredNames = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //needed to view custom navigation view with custom height
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        
        navigationView.layer.zPosition = -1
        
        let doctor = self.db.collection("doctors").document(doctorID!).collection("patients")
    
        fetchISVisited { result in
            switch result{
            case .success(let count):
                self.patientsTableView.reloadData()
            
            case .failure(let count):
                return
            }
   
        }
        
      
        
    }
    @objc func sayHey(){
        print("say hey")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //To avoid navigationbar getting hidden at next view
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("step 4")
        doctorName.text = userName
        print("patients count in patients view is \(Patients.sharedInstance.names.count)")
        filteredNames = names
        navigationView.layer.cornerRadius = 15
        //remove back word from navigation button item for next view
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        doctorID = defaults.string(forKey: "doctorID")
        
        //navigationController?.isToolbarHidden = true
        // navigationController?.isNavigationBarHidden = true
        //        let navigationBarAppearance = UINavigationBarAppearance()
        //                       //navigationBarAppearance.configureWithOpaqueBackground()
        //        navigationBarAppearance.backgroundColor = UIColor(red: 218/255, green: 229/255, blue: 218/255, alpha: 0.37)
        //                       navigationBarAppearance.titleTextAttributes = [
        //                        NSAttributedString.Key.foregroundColor :UIColor.white
        //                       ]
        //        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        
        
        //        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        //        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        //        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        //        navigationController?.toolbar.standardAppearance.backgroundColor = .red
        //        navigationItem.title = "fdfd"
        //        let height = CGFloat(45)
        //        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        
        
        self.patientsTableView.delegate = self
        self.patientsTableView.dataSource = self
        searchBar.delegate = self
        
        
        searchBar.layer.cornerRadius = 10
        //searchBar.layer.frame.size = CGSize(width: 100, height: 200)
        searchBar.updateHeight(height: 150,radius: 5)
        searchBarLeading.constant = patientsTableView.frame.width * 0.09
        searchBarTrailing.constant = patientsTableView.frame.width * 0.09
        
        let searchTextField:UITextField = searchBar.value(forKey: "searchField") as? UITextField ?? UITextField()
        searchTextField.textAlignment = NSTextAlignment.right
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "بحث",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        let searchIcon = UIImage(systemName: "magnifyingglass")!.withTintColor(.white, renderingMode: .alwaysOriginal)
        let imageView:UIImageView = UIImageView.init(image: searchIcon)
        
        searchTextField.leftView = imageView
        
        print("width is \(view.frame.width)")
        patientsTableView.rowHeight = view.frame.width * 0.23076923
        
        tableViewHeight.constant = view.frame.height * 0.25
        
        navBottomConstraint.constant =  view.frame.height * 0.86137441
        
        drPersonBtm.constant = view.frame.height * 0.03554502
        patientsTableView.register(UINib(nibName: "PatientTableViewCell", bundle: nil), forCellReuseIdentifier: "patientCell")
       
        
        
        
        //MARK: Side Menu
        // Side Menu Gestures
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            panGestureRecognizer.delegate = self
        panGestureRecognizer.cancelsTouchesInView = false  //needed to make tableview works properly
            view.addGestureRecognizer(panGestureRecognizer)
        
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false //needed to make tableview works properly
        view.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop {
            view.insertSubview(self.sideMenuShadowView, at: 2)
        }
        
        // Side Menu
        // Side Menu
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuID") as? SideMenuViewController
        self.sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        sideMenuViewController.name = userName
        self.sideMenuViewController.delegate = self
        view.insertSubview(self.sideMenuViewController!.view, at: self.revealSideMenuOnTop ? 7 : 0)
        addChild(self.sideMenuViewController!)
        self.sideMenuViewController!.didMove(toParent: self)
        
        
        print("fuck22")
        
        // Side Menu AutoLayout
        
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: +self.sideMenuRevealWidth + self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        // ...
        
        
        //sideMenuViewController.view.isUserInteractionEnabled = true
          //  sideMenuViewController.view.sendSubviewToBack(beforeEattingbtn)
//        self.view.bringSubviewToFront(self.sideMenuViewController.view)
       // beforeEattingbtn.layer.zPosition = -1
    
        // Default Main View Controller
       // showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
        
        sideMenuViewController.view.layer.zPosition = 2
        
       // sideMenuBtn.target = revealViewController()
         //revealViewController()?.revealSideMenu
        menuBtn.addTarget(revealViewController2(), action: #selector(revealViewController2()?.revealSideMenu2), for: .allEvents)
        //menuBtn.actions(forTarget: revealViewController2(), forControlEvent: .allEvents)
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        let height = CGFloat(45)
        //        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
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
    
    
    
    @IBAction func menuButton(_ sender: UIButton) {
        print("menu button pressed")
        searchBar.resignFirstResponder()
       // sideMenuViewController.view.layer.zPosition = 2
        
        //menuBtn.target = revealViewController()
               // menuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        
    }
    
    enum NetworkError: Error {
        case badURL
    }
    
    
    func fetchISVisited(completionHandler: @escaping (Result<Int, NetworkError>) -> Void)  {
       
        let doctor = self.db.collection("doctors").document(doctorID!).collection("patients")
    
        doctor.getDocuments { querySnapshot, err in
            
            if let err = err {
                print("error getting patients")
                self.alert(message: "error getting patients")
                completionHandler(.failure(.badURL))
                return
            }
            
            else {
                
                let child = SpinnerViewController()

                   // add the spinner view controller
                self.addChild(child)
                child.view.frame = self.view.frame
                self.view.addSubview(child.view)
               child.didMove(toParent: self)
                
                //iterating over patients collection getting their names and IDs
                for document in querySnapshot!.documents {
                    let tempPatient = Patient()
                   // self.myUserID = document.documentID
                    print("------------------------------------------------------------------------------------------------------------")

                    print("\(document.documentID) => \(document.data())")
                    print("------------------------------------------------------------------------------------------------------------")

                    let dataDescription = document.data()
                    Patients.sharedInstance.patientsID.append(document.documentID)
                    Patients.sharedInstance.names.append(dataDescription["Name"] as? String  ?? "no name")
                   
              
                    tempPatient.isVisited = dataDescription["isVisited"] as? Bool ?? false
                    Patients.sharedInstance.allPatients[document.documentID]?.isVisited = tempPatient.isVisited // append pateint object to allPatients dictionary
                    
                   
                        print("fucky must be after week1")
                    
                   // self.fetchPersonalInfo(userID: document.documentID,getNameOnly: true)
                }
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                print("step 1")
                completionHandler(.success(5))

                
               
              
            }
            
        }
    
    }
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
            
            if Patients.sharedInstance.allPatients[patientsID[indexPath.row]]?.isVisited == true {
                cell.readStatusView.isHidden = true
            } else {
                cell.readStatusView.isHidden = false
            }
           //
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell got selected")
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PatientDetail") as? PatientDetailViewController {
            vc.userID = Patients.sharedInstance.patientsID[indexPath.row]
            Patients.sharedInstance.allPatients[patientsID[indexPath.row]]?.isVisited = true
            let doc = self.db.collection("doctors").document(doctorID).collection("patients").document(patientsID[indexPath.row])
            doc.setData(["isVisited":true], merge: true)
            navigationController?.pushViewController(vc, animated: true)
        }
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
extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 51)
    }
}


extension PatientsViewController: SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            // Home
            print("home1")
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Doctor") as? DoctorViewController {
                vc.typeVC = "edit" //change flag so form opens in editting mode not registeration
               
                vc.userName = userName
                vc.docGovID = docGovID
                vc.nationalID = nationalID
                
                  navigationController?.pushViewController(vc, animated: true)
         
            }
        case 1:
            
            print("home2")
        default:
            print("broke")
            break
        }
        
        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }
    
    func showViewController<T: UIViewController>(viewController: T.Type, storyboardId: String) -> () {
        // Remove the previous View
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        vc.view.tag = 99
        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 2)
        addChild(vc)
        if !self.revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
            if self.sideMenuShadowView != nil {
                vc.view.addSubview(self.sideMenuShadowView)
                
            }
        }
        vc.didMove(toParent: self)
    }
    
    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
                print("yaudu")
                self.tabBarController?.tabBar.isHidden = true

            }
            // Animate Shadow (Fade In)
           

            UIView.animate(withDuration: 0.7) {
                self.sideMenuShadowView.alpha = 0.6
                self.tabBarController?.tabBar.alpha = 0
               // self.afterEattingbtn.isEnabled = false
                self.navigationItem.setRightBarButton(nil, animated: true)
            }
           
           
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (self.sideMenuRevealWidth + self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
                
                self.tabBarController?.tabBar.isHidden = false

            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.7) {
                self.sideMenuShadowView.alpha = 0.0
                self.tabBarController?.tabBar.alpha = 1
                //self.afterEattingbtn.isEnabled = true
               // self.navigationItem.setRightBarButton(self.menuBtn, animated: true)

            }
        }
    }
    
    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }
}
extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController2() -> PatientsViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is PatientsViewController {
         
            return viewController! as? PatientsViewController
        }
        while (!(viewController is PatientsViewController) && viewController?.parent != nil) {
            
            viewController = viewController?.parent
        }
        if viewController is PatientsViewController {
           
            return viewController as? PatientsViewController
        }
        return nil
    }
    // Call this Button Action from the View Controller you want to Expand/Collapse when you tap a button
    
    
}

extension PatientsViewController: UIGestureRecognizerDelegate {
    
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
        searchBar.resignFirstResponder()
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
    
    // Dragging Side Menu
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        // ...

        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x

        switch sender.state {
        case .began:

            // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
            if velocity > 0, self.isExpanded {
                sender.state = .cancelled
            }

            // If the user swipes right but the side menu hasn't expanded yet, enable dragging
            if velocity > 0, !self.isExpanded {
                self.draggingIsEnabled = true
            }
            // If user swipes left and the side menu is already expanded, enable dragging they collapsing the side menu)
            else if velocity < 0, self.isExpanded {
                self.draggingIsEnabled = true
            }

            if self.draggingIsEnabled {
                // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                let velocityThreshold: CGFloat = 550
                if abs(velocity) > velocityThreshold {
                    self.sideMenuState(expanded: self.isExpanded ? false : true)
                    self.draggingIsEnabled = false
                    return
                }

                if self.revealSideMenuOnTop {
                    self.panBaseLocation = 0.0
                    if self.isExpanded {
                        self.panBaseLocation = self.sideMenuRevealWidth
                    }
                }
            }

        case .changed:

            // Expand/Collapse side menu while dragging
            if self.draggingIsEnabled {
                if self.revealSideMenuOnTop {
                    // Show/Hide shadow background view while dragging
                    let xLocation: CGFloat = self.panBaseLocation + position
                    let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                    let alpha = percentage >= 0.6 ? 0.6 : percentage
                    self.sideMenuShadowView.alpha = alpha

                    // Move side menu while dragging
                    if xLocation <= self.sideMenuRevealWidth {
                        self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                    }
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                       // Show/Hide shadow background view while dragging
                        let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        self.sideMenuShadowView.alpha = alpha

                        // Move side menu while dragging
                        if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                            recogView.frame.origin.x = recogView.frame.origin.x + position
                            sender.setTranslation(CGPoint.zero, in: view)
                        }
                    }
                }
            }
        case .ended:
            self.draggingIsEnabled = false
            // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
            if self.revealSideMenuOnTop {
                let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                self.sideMenuState(expanded: movedMoreThanHalf)
            }
            else {
                if let recogView = sender.view?.subviews[1] {
                    let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
            }
        default:
            break
        }
    }
}
