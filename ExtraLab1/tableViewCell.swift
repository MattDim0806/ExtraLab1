//
//  tableViewCell.swift
//  ExtraLab1
//
//  Created by 楊皓麟 on 2023/4/20.
//

import UIKit

class tableViewCell: UITableViewCell {
    
    @IBOutlet weak var vicinityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(name: String, vicinity: String){
        nameLabel.text = name
        vicinityLabel.text = vicinity
    }
}
