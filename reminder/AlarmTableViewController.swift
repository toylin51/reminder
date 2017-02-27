//
//  AlarmTableViewController.swift
//  reminder
//
//  Created by LinTing-yang on 2017/2/12.
//  Copyright © 2017年 sample. All rights reserved.
//

import UIKit
class AlarmTableViewController: UITableViewController {

    @IBOutlet var toggle: UISwitch!
    @IBOutlet var date: UILabel!
    var pickerVisible = false
    var tempDate: Date?
    //var delegate: AlarmDelegate?
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggle.isOn = false
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    @IBAction func save(_ sender: Any) {
        if toggle.isOn && date.text != "Detail"{
            self.performSegue(withIdentifier: "unwindToEvent", sender: self)
        }
    }

    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        tableView.reloadData()
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = sender.calendar
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        tempDate = sender.date
        date.text = dateFormatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToEvent" {
            (segue.destination as! AddEventController).alarmData = tempDate!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            pickerVisible = !pickerVisible
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 && toggle.isOn == false {
            return 0.0
        }
        if indexPath.row == 2 {
            if toggle.isOn == false || pickerVisible == false {
                return 0.0
            }
            return 165.0
        }
        return 44.0
    }
}
