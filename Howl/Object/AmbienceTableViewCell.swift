//
//  AmbienceTableViewCell.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 03/05/21.
//

import UIKit

class AmbienceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            checkImage.isHidden = false
        } else {
            checkImage.isHidden = true
        }
    }
}
