//
//  DataTableViewController.swift
//  reminder
//
import UIKit

class DataTableViewController : UITableViewController{
    var events = NSMutableArray()
    
    let path : NSString = Bundle.main.path(forResource: "Events", ofType:  "plist")! as NSString
    let fileManager = FileManager.default
    let paths : NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    var documentsDirectory = NSString()
    var writablePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentsDirectory = paths.object(at: 0) as! NSString
        writablePath = documentsDirectory.appendingPathComponent("Events.plist")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 讀取 plist
    func firstLoadPlist() {
        
        if !fileManager.fileExists(atPath: writablePath){
            do{
                try fileManager.copyItem(atPath: path as String, toPath: writablePath)
            }catch{
                print("File exists")
            }
        }
        events = NSMutableArray(contentsOfFile: writablePath)!
    }
    
    //MARK: 讀取 plist
    func loadPlist() {
        events = NSMutableArray(contentsOfFile: writablePath)!
    }
    
    //MARK: 儲存編輯後的 plist
    func writePlist() {
        events.write(toFile: writablePath, atomically: true)
    }
    
    
    //MARK: 將資料寫入 plist
    func writePlist(title: String, content: String, date: [String], timeStemp: String) {
        let event = ["Title": title, "Content": content, "Date": date, "Stemp": timeStemp] as [String : Any]
        events.add(event)
        events.write(toFile: writablePath, atomically: true)
    }
}
