//
//  PersonalMusicTableViewCell.swift
//  PirateRadio
//
//  Created by A-Team Intern on 1.07.21.
//

import UIKit

class PersonalMusicTableViewCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
