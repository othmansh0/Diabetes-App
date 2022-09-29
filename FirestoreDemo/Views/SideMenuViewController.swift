//
//  SideMenuViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 9/9/22.
//

import UIKit
protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}
class SideMenuViewController: UIViewController {

    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var patientName: UILabel!
    var name = ""
    
    var delegate: SideMenuViewControllerDelegate?
    var defaultHighlightedCell: Int = 0
    var phoneImage = UIImage(systemName: "phone")
    
    
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(named: "editPencil")!, title: "تعديل البيانات "),
        SideMenuModel(icon: UIImage(systemName: "phone")!, title: "تواصل معنا"),
        SideMenuModel(icon: UIImage(named: "testAI")!, title: "الفحص ")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = #colorLiteral(red: 0.549633503, green: 0.6699408889, blue: 0.6940098405, alpha: 1)
        self.sideMenuTableView.separatorStyle = .singleLine
        sideMenuTableView.separatorColor = .white
        sideMenuTableView.allowsSelection = true
        
        // Set Highlighted Cell
//        DispatchQueue.main.async {
//            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
//            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
//        }
        sideMenuTableView.allowsSelection = true
  
        
        patientName.text = name
        
        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        self.sideMenuTableView.isEditing = false
        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }
}



// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    
  
}

// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
        if(indexPath.row == 1) {
            
            cell.iconImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        cell.iconImageView.image = self.menu[indexPath.row].icon
    
        cell.titleLabel.text = self.menu[indexPath.row].title
        
        // Highlighted color
//        let myCustomSelectionColorView = UIView()
//        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9421719313, green: 0.9421718717, blue: 0.9421718717, alpha: 1)
//        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
        // ...
        tableView.deselectRow(at: indexPath, animated: true)
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
//        if indexPath.row == 4 || indexPath.row == 6 {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    }
}
