//
//  AHASegmentCellTableViewCell.swift
//  AHA
//
//  Created by Justin Warmkessel on 5/6/16.
//  Copyright © 2016 Justin Warmkessel. All rights reserved.
//

import UIKit

class AHASegmentCellTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var ornamentationImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
