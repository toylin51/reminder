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
    
    var delegate: SwicthDelegate?
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        self.delegate?.getSwitch(isOn: sender.isOn)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateSwitch.isOn = false
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
