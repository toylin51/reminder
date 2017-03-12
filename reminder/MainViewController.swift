//
//  MainViewController.swift
//  reminder
//

import UIKit
import UserNotifications

class MainViewController: DataTableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()        
        firstLoadPlist()
        tableView.rowHeight = 64.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Back to Menu
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        events = NSMutableArray(contentsOfFile: writablePath)!
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    //MARK: Delete Cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
