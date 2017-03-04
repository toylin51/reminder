//
//  ViewController.swift
//  reminder
//

import UIKit
import UserNotifications

class ViewController: ReminderDataViewController, UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    //@IBOutlet var toolBar: UIToolbar!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventContent: UILabel!
    
    // 取得螢幕的尺寸
    let fullScreenSize = UIScreen.main.bounds.size
    
    //MARK: Back to Menu
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        events = NSMutableArray(contentsOfFile: writablePath)!
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.allowsMultipleSelectionDuringEditing = true
        //setEditing(false, animated: true)
        tableView.frame = CGRect(origin: CGPoint(x:0,y:64), size: CGSize(width:fullScreenSize.width,height:fullScreenSize.height-64))
        //toolBar.isHidden = true
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
        
        let event =  (events.object(at: indexPath.row) as AnyObject)
        
        cell.eventTitle.text = event.object(forKey: "Title") as? String
        cell.eventContent.text = event.object(forKey: "Content") as? String
        let dateArr = event.object(forKey: "Date") as? [String]
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "show"  {
            let indexPath =  self.tableView.indexPathForSelectedRow
            let updateEvent = segue.destination as! EventViewController
            let row = indexPath!.row
            let event =  (events.object(at: row) as AnyObject)
            
            updateEvent.isUpdate = true
            updateEvent.eventTitle = event.object(forKey: "Title") as! String
            updateEvent.eventContent = event.object(forKey: "Content") as! String
            updateEvent.timeStemp = event.object(forKey: "Stemp") as? String
            updateEvent.dateComponents = event.object(forKey: "Date") as! [String]
            updateEvent.indexOfEvent = row
        }
    }
}
