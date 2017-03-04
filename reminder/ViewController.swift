//
//  ViewController.swift
//  reminder
//

import UIKit
import UserNotifications

class ViewController: ReminderDataViewController, UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventContent: UILabel!
    
    // 取得螢幕的尺寸
    let fullScreenSize = UIScreen.main.bounds.size
    
    //MARK: Edit Button
    @IBAction func editButton(_ sender: Any) {
        if !isEditing {
            setEditing(true, animated: true)
            toolBar.isHidden = false
            tableView.frame = CGRect(origin: CGPoint(x:0,y:64), size: CGSize(width:fullScreenSize.width,height:fullScreenSize.height-109))
        }else{
            setEditing(false, animated: true)
            toolBar.isHidden = true
            tableView.frame = CGRect(origin: CGPoint(x:0,y:64), size: CGSize(width:fullScreenSize.width,height:fullScreenSize.height-64))
        }
    }
    
    //MARK: Multi Delete Button
    @IBAction func deleteButton(_ sender: Any) {
        var selectedIndexs = IndexSet()
        var removeNotifications = [String]()
        if let selectedItems = tableView!.indexPathsForSelectedRows {
            for indexPath in selectedItems {
                let stemp = (events.object(at: indexPath.row) as AnyObject).object(forKey: "Stemp") as? String
                removeNotifications.append(stemp!)
                selectedIndexs.insert(indexPath.row)
            }
        }
        
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: removeNotifications)
        events.removeObjects(at: selectedIndexs)
        writePlist()
        tableView?.reloadData()
        toolBar.isHidden = true
        tableView.setEditing(false, animated: true)
        tableView.frame = CGRect(origin: CGPoint(x:0,y:64), size: CGSize(width:fullScreenSize.width,height:fullScreenSize.height-64))
    }
    
    //MARK: Back to Menu
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        events = NSMutableArray(contentsOfFile: writablePath)!
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        setEditing(false, animated: true)
        tableView.frame = CGRect(origin: CGPoint(x:0,y:64), size: CGSize(width:fullScreenSize.width,height:fullScreenSize.height-64))
        toolBar.isHidden = true
        firstLoadPlist()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.accessoryType = .disclosureIndicator
        
        cell.eventTitle.text = (events.object(at: indexPath.row) as AnyObject).object(forKey: "Title") as? String
        cell.eventContent.text = (events.object(at: indexPath.row) as AnyObject).object(forKey: "Content") as? String
        let dateArr = (events.object(at: indexPath.row) as AnyObject).object(forKey: "Date") as? [String]
        if dateArr?.count != 0{
            cell.imgView.image = UIImage(named: "ic_alarm.png")
        }else{
            cell.imgView.image = UIImage(named: "ic_alarm_off.png")
        }
        
        return cell
    }
    
    
    //MARK: Delete Cell
    func tableView(_ tableView: UITableView,  commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)  {
        if editingStyle == .delete {
            let timeStemp = (events.object(at: indexPath.row) as AnyObject).object(forKey: "Stemp") as? String
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [timeStemp!])
            events.removeObject(at: indexPath.row)
            writePlist()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension ViewController{
    //改變編輯按鈕名稱
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
        
        if editing {
            self.navigationItem.rightBarButtonItem!.image = nil
            self.navigationItem.rightBarButtonItem!.title = "Done"
        } else {
            self.navigationItem.rightBarButtonItem!.title = ""
            self.navigationItem.rightBarButtonItem!.image = UIImage(named: "ic_list.png")
        }
    }
}
