//
//  HCCPFormsViewVC.swift
//  PestigeApp
//
//  Created by OmninosiOS on 2/17/18.
//  Copyright © 2018 omninos. All rights reserved.
//

import UIKit
import FSCalendar

class HCCPFormsViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource,FSCalendarDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var tableView: UITableView!
    var catNames = NSMutableArray()
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var backBlackBtn: UIButton!
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCloseBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var indicatorView: UIView!
    var resultArray = NSArray()
    var newResultArray = NSMutableArray()
    var filteredData: [String]!
    var SearchBarValue:String!
    var searchActive : Bool = false
    let data = ["10/12/2017","11/12/2017","12/12/2017","13/12/2017","14/12/2017"]
    var contractId = String()
    var scopeGesture = UIPanGestureRecognizer()
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    override func viewDidLoad() {
       super.viewDidLoad()
       
        filteredData = data
        searchCloseBtn.isHidden = true
        searchBar.showsCancelButton = false
        fsCalendar.isHidden = true
        backBlackBtn.isHidden = true
        helpView.isHidden = true
        searchBar.isHidden = true
        catNames = ["","","","","",""]
        contractId = UserDefaults.standard.value(forKey: "contractId") as! String
        openingClosingCheckListAPI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        openingClosingCheckListAPI()
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okBtnAction(_ sender: UIButton) {
        helpView.isHidden = true
        backBlackBtn.isHidden = true
    }
    
    @IBAction func helpBtnAction(_ sender: UIButton) {
        helpView.isHidden = false
        backBlackBtn.isHidden = false
    }
    
    @IBAction func searchBtnAction(_ sender: UIButton) {
       fsCalendar.isHidden = false
       searchBar.isHidden = false
       searchCloseBtn.isHidden = false
    }
    
    @IBAction func searchCloseBtnAction(_ sender: UIButton) {
        searchBar.isHidden = true
        searchCloseBtn.isHidden = true
    }
    
 // MARK ---------------------- SearchBar Delegates ----------------------
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.isHidden = true
        searchBar.text = nil
//        searchBar.resignFirstResponder()
//        tableView.resignFirstResponder()
//        self.searchBar.showsCancelButton = false
//        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
 // MARK ------------------ TableView Delegates & Datasources -----------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchBar.isHidden == true {
        return 1
    }
        else {
            return filteredData.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HCCPFormViewCustomTableViewCell
        cell?.selectionStyle = .none
        cell?.dateLabel.text = (self.newResultArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "updated") as? String
        cell?.nameLabel.text = (self.newResultArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as? String
        
        let newChanges = (self.newResultArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "new_changes") as? String
        if newChanges == "yes" {
            cell?.newChangesImageView.image = #imageLiteral(resourceName: "success")
        }
        else {
            cell?.newChangesImageView.image = #imageLiteral(resourceName: "Cancel")
        }
        
        let newStaff = (self.newResultArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "new_staff") as? String
        
        if newStaff == "yes" {
            cell?.newStaffImageView.image = #imageLiteral(resourceName: "success")
        }
        else {
            cell?.newStaffImageView.image = #imageLiteral(resourceName: "Cancel")
        }
        
        let opening = (self.newResultArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "opening_checks") as? String
        
        if opening == "yes" {
            cell?.openingImageView.image = #imageLiteral(resourceName: "success")
        }
        else {
            cell?.openingImageView.image = #imageLiteral(resourceName: "Cancel")
        }
        
//        if indexPath.row == 3 {
//            cell?.openingImageView.image = #imageLiteral(resourceName: "Error")
//        }
//
//        else if indexPath.row == 5 {
//            cell?.closingImageView.image = #imageLiteral(resourceName: "Error")
//        }
//
//        else if indexPath.row == 2 {
//            cell?.newStaffImageView.image = #imageLiteral(resourceName: "Error")
//        }
//
//        else if indexPath.row == 4 {
//            cell?.newChangesImageView.image = #imageLiteral(resourceName: "Error")
//        }
//
//        else if indexPath.row == 1 {
//            cell?.statusImageView.image = #imageLiteral(resourceName: "Cancel")
//        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "openingClosingChecksVC") as! openingClosingChecksVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "openingClosingChecksVC") as! openingClosingChecksVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        let kCellActionWidth = CGFloat(70.0)// The width you want of delete button
//        let kCellHeight = tableView.frame.size.height // The height you want of delete button
//        let whitespace = whitespaceString(width: kCellActionWidth)
        
        let editAction = UITableViewRowAction(style: .default, title: "edit", handler: { (action, indexPath) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "openingClosingChecksVC") as! openingClosingChecksVC
            self.navigationController?.pushViewController(vc, animated: true)
           /* let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
              //  textField.text = self.list[indexPath.row]
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
               // self.list[indexPath.row] = alert.textFields!.first!.text!
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)*/
        })
        
//        let view1 = UIView(frame: CGRect(x: tableView.frame.size.width-100, y: 0, width: 70, height: kCellHeight))
//        view1.backgroundColor = UIColor.green // background color of view
//        let imageView1 = UIImageView(frame: CGRect(x: 15,
//                                                  y: 20,
//                                                  width: 40,
//                                                  height: 40))
//        imageView1.image = UIImage(named: "edit")! // required image
//        view1.addSubview(imageView1)
//        let image1 = view1.image()
//        editAction.backgroundColor = UIColor.init(patternImage: image1)
        editAction.backgroundColor = UIColor(red: 47/255, green: 158/255, blue: 89/255, alpha: 1.0)
        
        let deleteAction = UITableViewRowAction(style: .default, title: "delete", handler: { (action, indexPath) in
            self.newResultArray.removeObject(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            tableView.reloadData()
        })
        
//        let view = UIView(frame: CGRect(x: tableView.frame.size.width-100, y: 0, width: 70, height: kCellHeight))
//        view.backgroundColor = UIColor(red: 219.0/255.0, green: 71.0/255.0, blue: 95.0/255.0, alpha: 1.0) // background color of view
//        let imageView = UIImageView(frame: CGRect(x: 15,
//                                                  y: 20,
//                                                  width: 40,
//                                                  height: 40))
//        imageView.image = UIImage(named: "Delete")! // required image
//        view.addSubview(imageView)
//        let image = view.image()
//        deleteAction.backgroundColor = UIColor.init(patternImage: image)
        
        deleteAction.backgroundColor = UIColor(red: 219.0/255.0, green: 71.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        
        return [deleteAction, editAction]
    }
    
 // MARK ----------------- FSCalendar Delegate ----------------------------
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        searchBar.text = self.dateFormatter.string(from: date)
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        fsCalendar.isHidden = true
        searchBar(searchBar, textDidChange: searchBar.text!)
    }
    
    fileprivate func whitespaceString(font: UIFont = UIFont.systemFont(ofSize: 15), width: CGFloat) -> String {
        let kPadding: CGFloat = 20
        let mutable = NSMutableString(string: "")
        let attribute = [NSAttributedStringKey.font: font]
        while mutable.size(withAttributes: attribute).width < width - (2 * kPadding) {
            mutable.append(" ")
        }
        return mutable as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openingClosingCheckListAPI() {
        let dict : NSDictionary = ["contract_id": contractId]
        print(dict)
        
        Global().alamofire_withMethod(method: "OpeningClosingChecksList", parameters: dict, completion: {result in
            print(result)
//            let successResult = result["success"] as? String
//            print(successResult!)
            let list = result["checks_list"] as! NSArray
            print(list)
            self.resultArray = list
            print(self.resultArray.count)
            self.newResultArray = (self.resultArray.mutableCopy() as! NSMutableArray)
            self.tableView.reloadData()
        }, failure: { failure in
            print(failure)
        })
    }
}

extension UIView {
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        }
}
