//
//  AddEventController.swift
//  reminder
//

import UIKit
import UserNotifications

class AddEventController: ReminderDataViewController {
    
    @IBOutlet var myTitle: UITextField!
    @IBOutlet var myContent: UITextView!
    
    var eventTitle = ""
    var eventContent = ""
    var dateComponents = [String]()
    var alarmData: Date?
    var timeStemp: String?
    
    // 取得螢幕的尺寸
    let fullScreenSize = UIScreen.main.bounds.size
    
    //MARK: 儲存資料
    @IBAction func save(_ sender: Any) {
        eventTitle = myTitle.text!
        eventContent = myContent.text
        if eventTitle == "" { eventTitle = "New Event" }
        if eventContent == "" { eventContent = "No Content" }
        if (timeStemp == nil) { timeStemp = getCurrentTime() }
        
        //寫入資料
        writePlist(title: eventTitle, content: eventContent, date: dateComponents, timeStemp: timeStemp!)
        
        //觸發通知
        if dateComponents.count != 0{
            triggerNotification()
        }
        
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTextView()
        loadPlist()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMenu" {
            
        }
    }
    
    //MARK: Back to Event
    @IBAction func unwindToEvent(segue: UIStoryboardSegue) {
        if alarmData != nil{
            formatDate(date: self.alarmData!)
        }
    }
    
    //MARK: 格式化時間
    func formatDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateComponents.append(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "dd"
        dateComponents.append(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "H"
        dateComponents.append(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "mm"
        dateComponents.append(dateFormatter.string(from: date))
    }
    
    //MARK: 自訂TextView
    func customizeTextView(){
        myContent.layer.cornerRadius = 10
    }
    
    //MARK: 觸發通知
    func triggerNotification(){
        let content = UNMutableNotificationContent()
        content.title = eventTitle
        content.body = eventContent
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        var date = DateComponents()
        date.month = Int(dateComponents[0])
        date.day = Int(dateComponents[1])
        date.hour = Int(dateComponents[2])
        date.minute = Int(dateComponents[3])
        
        timeStemp = getCurrentTime()
        
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: timeStemp!, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    //MARK: Get current Time
    func getCurrentTime() -> String {
        let currentTime = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: Date()).description
        return currentTime
    }
}

