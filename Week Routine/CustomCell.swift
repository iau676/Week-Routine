//
//  CustomCell.swift
//  Week Routine
//
//  Created by ibrahim uysal on 7.10.2022.
//

import UIKit

class CustomCell: UITableViewCell {
    
    static let identifier = "ReusableCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var sView: UIStackView!
    @IBOutlet weak var titleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
