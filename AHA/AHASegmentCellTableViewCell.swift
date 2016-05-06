//
//  AHASegmentCellTableViewCell.swift
//  AHA
//
//  Created by Justin Warmkessel on 5/6/16.
//  Copyright © 2016 Justin Warmkessel. All rights reserved.
//

import UIKit

protocol AHASegmentCellDelegate {
    func didTapCell(cell: AHASegmentCellTableViewCell)
}

class AHASegmentCellTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var ornamentationImageView: UIImageView!

    var delegate : AHASegmentCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    @IBAction func playButtonHandler(sender: AnyObject) {
        print("play")

        if let delegate = delegate {
            delegate.didTapCell(self)
        }
    }
}
