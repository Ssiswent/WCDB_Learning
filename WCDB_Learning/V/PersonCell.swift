//
//  PersonCell.swift
//  WCDB_Learning
//
//  Created by Flamingo on 2021/3/29.
//

import UIKit

class PersonCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    var model: Person? {
        didSet {
            nameLabel.text = model?.name
            sexLabel.text = model?.sex
            if let age = model?.age {
                ageLabel.text = "\(age)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
    }
}
