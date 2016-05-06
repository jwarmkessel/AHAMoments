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
    @IBOutlet weak var ornamentationImageViewTop: UIImageView!
    @IBOutlet weak var ornamentationImageViewBottom: UIImageView!

    var delegate : AHASegmentCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func playButtonHandler(sender: AnyObject) {
        print("play")

        if let delegate = delegate {
            delegate.didTapCell(self)
        }
    }

    override func prepareForReuse() {
        ornamentationImageView.hidden = true
        ornamentationImageViewTop.hidden = true
        ornamentationImageViewBottom.hidden = true
    }
}
