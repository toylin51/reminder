//
//  SwitchTableCell.swift
//  reminder
//

import UIKit

protocol SwicthDelegate {
    func getSwitch(isOn: Bool)
}

open class SwitchTableCell: UITableViewCell {
    
    @IBOutlet fileprivate var dateSwitch: UISwitch!
    //let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    var delegate: SwicthDelegate?
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        self.delegate?.getSwitch(isOn: sender.isOn)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //dateSwitch.addTarget(self, action: #selector(SwitchTableCell.save(_:)), for: .valueChanged)

        //delegate = storyBoard.instantiateViewController(withIdentifier: "AddAlarm") as! AddAlarmController
        dateSwitch.isOn = false
    }
    
    // MARK: Save
    /*
    func save(_ sender: UISwitch) {
        //self.dateSwitch.isOn = !self.dateSwitch.isOn
        self.delegate?.getSwitch(isOn: sender.isOn)
    }
 */
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
