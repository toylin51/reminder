//
//  CustomTableViewCell.swift
//  reminder
//
import UIKit

class CustomTableViewCell: UITableViewCell {
    
    //MARK: UI
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventContent: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
