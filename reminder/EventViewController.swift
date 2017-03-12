//
//  EventViewController.swift
//  reminder
//

import UIKit
import UserNotifications

class EventViewController: DataTableViewController {
    
    @IBOutlet var myTitle: UITextField!
    @IBOutlet var myContent: UITextView!
    @IBOutlet var myTime: UILabel!
    
    //存檔用的變數
    var eventTitle = ""
    var eventContent = ""
    var dateComponents = [String]()
    var alarmData: Date?
    var timeStemp: String?
    
    //更新資料時的變數
    var isUpdate = false
    var indexOfEvent = 0
    
    @IBAction func save(_ sender: Any) {
        eventTitle = myTitle.text!
        eventContent = myContent.text
        if eventTitle == "" { eventTitle = "New Event" }
        if eventContent == "" { eventContent = "No Content" }
        if (timeStemp == nil) { timeStemp = getCurrentTime() }
        
        if !isUpdate{
            //寫入資料
            writePlist(title: eventTitle, content: eventContent, date: dateComponents, timeStemp: timeStemp!)
        }else{
            //更新資料
            updatePlist(title: eventTitle, content: eventContent, date: dateComponents, timeStemp: timeStemp!, index: indexOfEvent)
        }
        //觸發通知
        if dateComponents.count != 0{
            triggerNotification()
        }
        
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUpdate{
            myTitle.text = eventTitle
            myContent.text = eventContent
            if dateComponents.count != 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.short
                
                var date = DateComponents()
                date.year = Int(dateComponents[0])
                date.month = Int(dateComponents[1])
                date.day = Int(dateComponents[2])
                date.hour = Int(dateComponents[3])
                date.minute = Int(dateComponents[4])
                
                alarmData = Calendar.current.date(from: date)
                myTime.text = dateFormatter.string(from: alarmData!)
            }
        }
        loadPlist()
    }
    
    //MARK: Back to Event
    @IBAction func unwindToEvent(segue: UIStoryboardSegue) {
        if alarmData != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.short
            myTime.text = dateFormatter.string(from: alarmData!)
            
            formatDate(date: self.alarmData!)
        }else{
            myTime.text = "None"
            dateComponents = []
        }
    }
    
    //MARK: Table View Configuration
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    //MARK: 格式化時間
    func formatDate(date: Date) {
        dateComponents = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateComponents.append(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "MM"
        dateComponents.append(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "dd"
        dateComponents.append(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "H"
        dateComponents.append(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "mm"
        dateComponents.append(dateFormatter.string(from: date))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 觸發通知
    func triggerNotification(){
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = eventContent
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        var date = DateComponents()
        date.year = Int(dateComponents[0])
        date.month = Int(dateComponents[1])
        date.day = Int(dateComponents[2])
        date.hour = Int(dateComponents[3])
        date.minute = Int(dateComponents[4])
        
        if (timeStemp == nil) { timeStemp = getCurrentTime() }
        
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: timeStemp!, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    //MARK: 取得現在時間
    func getCurrentTime() -> String {
        let currentTime = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: Date()).description
        return currentTime
    }
    
}
