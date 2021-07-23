//
//  MusicCollectionTableViewCell.swift
//  PirateRadio
//
//  Created by A-Team Intern on 19.07.21.
//

import UIKit

class MusicCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionImageView: UIImageView!
    @IBOutlet weak var sectionTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }    
}
