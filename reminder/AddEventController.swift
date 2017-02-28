//
//  AddEventController.swift
//  reminder
//

import UIKit

class AddEventController: ReminderDataViewController {
    
    @IBOutlet var myTitle: UITextField!
    @IBOutlet var myContent: UITextView!
    var dateComponents = [String]()
    var alarmData: Date?
    
    // 取得螢幕的尺寸
    let fullScreenSize =
        UIScreen.main.bounds.size
    
    //MARK: 儲存資料
    @IBAction func save(_ sender: Any) {
        var eventTitle = myTitle.text
        var eventContent = myContent.text
        if eventTitle == "" { eventTitle = "New Event" }
        if eventContent == "" { eventContent = "No Content" }
        //寫入資料
        writePlist(title: eventTitle!, content: eventContent!, date: dateComponents)
        
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
        dateFormatter.dateFormat = "h"
        dateComponents.append(dateFormatter.string(from: date))
        dateFormatter.dateFormat = "mm"
        dateComponents.append(dateFormatter.string(from: date))
    }
    
    //MARK: 自訂TextView
    func customizeTextView(){
        myContent.layer.cornerRadius = 10
    }
    
}
