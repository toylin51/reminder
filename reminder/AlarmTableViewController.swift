//
//  AlarmTableViewController.swift
//  reminder
//

import UIKit

class AlarmTableViewController: UITableViewController {
    
    @IBOutlet var toggle: UISwitch!
    @IBOutlet var date: UILabel!
    var pickerVisible = false
    var tempDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggle.isOn = false
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    @IBAction func save(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToEvent", sender: self)
        
    }
    
    @IBAction func toggleValueChanged(_ sender: UISwitch) {
        if toggle.isOn{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.short
            tempDate = Date()
            date.text = dateFormatter.string(from: tempDate!)
        }
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
            if tempDate != nil && toggle.isOn{
                (segue.destination as! EventViewController).alarmData = tempDate!
            }else{
                (segue.destination as! EventViewController).alarmData = nil
            }
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
